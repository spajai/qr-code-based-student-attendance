package QRAttendance::Controller::Qrcode;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config->{namespace} = 'api/v1';

use QRAttendance::API::Qrcode;
use QRAttendance::Utils;

has 'qrcode_api' => (
    is            => 'ro',
    isa           => 'QRAttendance::API::Qrcode',
    default       => sub { QRAttendance::API::Qrcode->new },
    lazy          => 1
);
has 'utils' => (
    is            => 'ro',
    isa           => 'QRAttendance::Utils',
    default       => sub { QRAttendance::Utils->new },
    lazy          => 1
);
=pod

get_qr_info

type get used to get info used by both student and teacher

return meaningful response code and message

=cut
sub get_qr_info : GET Path('qr-info') Args(1) Does('CheckUrlPermission') {
    my ( $self, $c, $qrcode ) = @_;
    if(! defined $qrcode || length ($qrcode) != 36) {
        $c->stash->{data} = {
            result     => 'error',
            error      => 'required_param_missing',
            data       => "Missing required attr valid qr code needed or user type is not Student"
        };
        return;
    }

    my $res = $self->qrcode_api->qr_info($qrcode, $c->stash->{session_user_id});
    $c->stash->{data} = $res;
    return;
}
=pod

qr_check_in

type post used to mark attendance used by student only

return meaningful response code and message

=cut
sub qr_check_in : POST Path('qr-check-in') Args(1) Does('CheckUrlPermission') {
    my ( $self, $c , $qrcode) = @_;

    if(! defined $qrcode || length ($qrcode) != 36 || $c->stash->{session_user_type} ne 'Student') {
        $c->stash->{data} = {
            result     => 'error',
            error      => 'required_param_missing',
            data       => "Missing required attr valid qr code needed or user type is not Student"
        };
        return;
    }

    my $res = $self->qrcode_api->qr_check_in($qrcode, $c->stash->{session_user_id});
    $c->stash->{data} = $res;
    return;
}
