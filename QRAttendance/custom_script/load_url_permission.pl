#!/usr/bin/perl

use strict;
use warnings;

use Text::CSV;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QRAttendance::DB;
# use QRAttendance::DB::Common;

my $file = $ARGV[0] || undef;
if ( !defined $file ) {
    die "Please provide url_permissions.csv file\n";
}

my $db_obj = QRAttendance::DB->new->get_dbi_db_con();

sub csv_to_ds {
    my $file = shift;

    my @rows;
    if ($file) {
        my $csv = Text::CSV->new( { binary => 1, auto_diag => 1 } );

        open my $fh, "<:encoding(utf8)", $file or die $file . ": $!";
        my $cols = $csv->getline($fh);

        $csv->column_names($cols);

        my @data;
        while ( my $row = $csv->getline_hr($fh) ) {

            my @http_methos = split /\|/, $row->{http_method};
            my @permissions = split /\|/, $row->{permission_group};

            foreach my $http_method (@http_methos) {
                foreach my $permission (@permissions) {
                    my $params = [
                        $row->{type}, $row->{name}, $row->{prefix},
                        $row->{path}, $permission,  $http_method
                    ];
                    push( @rows, $params );
                }
            }
        }
        close $fh;
    }
    return \@rows;
}

my $row_data = &csv_to_ds($file);

my $dbh = $db_obj->{dbh};
$dbh->do('DELETE FROM url_permissions');
my $insert_sql = q/INSERT INTO url_permissions(type,name,prefix,path,permission_group,http_method) VALUES(?,?,?,?,?,?)/;
my $sth = $dbh->prepare($insert_sql);

foreach my $row ( @{$row_data} ) {
    $sth->execute( @{$row} );
}