#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QRAttendance::API::Qrcode;

use Data::Dumper;
use QRAttendance::Utils;
# use QRAttendance::DB::Utils;

# invalid or expired qr code

note("invalid or expired qr code");
my $count = 0;
{
    local *QRAttendance::DB::Utils::fetch_row_hashref = sub {
        my ($self, $data) = @_;
        if($count == 0) {
            is(scalar @_, 2 ,"Right number of param received");
            ok(1, "Mocked DB util called");
            is_deeply( 
                $data->{binds},
                [ 'bde1b739-b74d-47a2-9023-dc307bed02af' ],
                "Correct Parameter received"
            );
            $count++;
            return undef;
        }
    };
    my $qr_obj = QRAttendance::API::Qrcode->new;
    my $res = $qr_obj->qr_check_in('bde1b739-b74d-47a2-9023-dc307bed02af',1);

    is_deeply(
        $res,
        {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => qq/Invalid Request There could be several reason 
                        1. Invalid QR code or Expired
                        2. QR code has been expired/
        },
     "got epected bahviour"
    );
}

done_testing();
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut