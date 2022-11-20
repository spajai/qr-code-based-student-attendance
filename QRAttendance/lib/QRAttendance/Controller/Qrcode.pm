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

sub get_lectures : GET Path('lecture') Args() Does('CheckUrlPermission') {
    my ( $self, $c, $date ) = @_;


}

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

    my $res = $self->lecture_api->qr_check_in($qrcode, $c->stash->{session_user_id});
    $c->stash->{data} = $res;
    return;
}
