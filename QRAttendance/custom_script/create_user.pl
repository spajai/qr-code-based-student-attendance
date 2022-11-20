#!/usr/bin/perl

use strict;
use warnings;

use Text::CSV;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Data::Dumper;
use QRAttendance::Password::argon2;

use QRAttendance::DB;
my $file = $ARGV[0] || undef;
if ( !defined $file ) {
    die "Please provide user csv file\n";
}

my $db_obj      = QRAttendance::DB->new->get_dbi_db_con();
my $entropy_obj = QRAttendance::Password::argon2->new();

my @col_data = qw/email password username type first_name last_name sex phone device_token dob/;
sub csv_to_ds {
    my $file = shift;

    my @rows;
    if ($file) {
        my $csv = Text::CSV->new( { binary => 1, auto_diag => 1 } );

        open my $fh, "<:encoding(utf8)", $file or die $file . ": $!";
        my $cols = $csv->getline($fh);

        $csv->column_names($cols);

        while ( my $row = $csv->getline_hr($fh) ) {
            my $raw_pass = delete $row->{password};
            $row->{password} = $entropy_obj->get_password_hash($raw_pass);
            my $course = delete $row->{course};
            my $type = $row->{type};
            my @data;
            foreach(@col_data) {
                push (@data,$row->{$_});
            }

            push @rows, {data => \@data, course => $course, type => $type};
        }
        close $fh;
    }
    return \@rows;
}

my $row_data = &csv_to_ds($file);

my $dbh = $db_obj->{dbh};
foreach my $data ( @$row_data) {

    my @data = @{$data->{data}};
    my $insert_sql = 'INSERT INTO users('. join(',',@col_data) .') VALUES(?,?,?,?,?,?,?,?,?,?) on conflict do nothing RETURNING ID';
    my $sth = $dbh->prepare($insert_sql);
    my $res = $sth->execute( @data );
    my $course_code = $data->{course};
    my $type        = $data->{type};
    if($res eq '0E0') {
        print "Error ($res) while creating user [". join (',', @data) ."] \n";
    } else {
        my $user_id = $sth->fetchrow_hashref->{id};
        print "Success id($user_id) user created [". join (',', @data) ."] \n";
        if($type eq 'Teacher') {
            my $sql = "INSERT INTO teacher_courses(user_id,course_id) VALUES($user_id,(select id from courses where lower(code) =lower('$course_code'))) on conflict do nothing RETURNING ID";
            my $sth_t = $dbh->prepare($sql);
            $sth_t->execute();
            print "Teacher course_code registered $course_code \n";
        } elsif($type eq 'Student') {
            my $sql = "INSERT INTO student_courses(user_id,course_id) VALUES($user_id,(select id from courses where lower(code) = lower('$course_code'))) on conflict do nothing RETURNING ID";
            my $sth_s = $dbh->prepare($sql);
            $sth_s->execute();
            print "Student course_code registered $course_code \n";
        }
    }
}