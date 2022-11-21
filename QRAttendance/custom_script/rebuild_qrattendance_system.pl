use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use QRAttendance::DB;

my $risk_db_damage = $ENV{RISK_DB_DAMAGE} || 0;
die "Risk to database damage detected. Set 'RISK_DB_DAMAGE' to continue. Aborting!" if (!$risk_db_damage);

my $db_obj = QRAttendance::DB->new->get_dbi_db_con();
my $dbh = $db_obj->{dbh};
my $root = '/home/sushrut/upwrk_student_attendance/QRAttendance';
my $sql_dir = $root . "/sql";

# Fetch schema file
&execute_file_content($sql_dir . '/schema.sql');

# Fetch Views
my @views = &get_sql_files($sql_dir . '/View');
foreach my $file (sort @views) {
    &execute_file_content($file);
}

# Fetch SP
my @sp = &get_sql_files($sql_dir . '/StoredProcedure');
foreach my $file (sort @sp) {
    &execute_file_content($file);
}

# print "Load url permission\n";
&execute_command('perl ' . $root . '/custom_script/load_url_permission.pl ' . $root . '/data/url_permission.csv');

# print "Load user\n";
&execute_command('perl ' . $root . '/custom_script/create_user.pl ' . $root . '/data/default_users.csv');

sub execute_file_content {
    my ($filename) = @_;

    local $/ = undef;

    open my $fh, '<',$filename or die "Can't open $filename: $!";
    my $content = <$fh>;
    close $fh; 

    print "File: $filename\n";
    $dbh->do($content);
}

sub get_sql_files {
    my ($dir) = @_;
    return unless (defined $dir);

    opendir(DIR, $dir) or die "$!";
    my @file_name;
    while (my $file = readdir(DIR)) {
        my $loc = "$dir/$file";
        next unless (-f $loc && $loc =~ /\.sql$/);
        push(@file_name, $loc);
    }

    return @file_name;
}

sub execute_command {
    my ($cmd) = shift;

    print "EXEC: $cmd\n";
    system($cmd);
}
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut