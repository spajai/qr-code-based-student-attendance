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

{
    "data": {
        "all_present_student": [
            "david smith"
        ],
        "all_absent_student": null,
        "total_present": 1,
        "qr_data": {
            "course_name": "Machine Learning",
            "lecture_status": "Scheduled",
            "qr_code": "bde1b739-b74d-47a2-9023-dc307bed02af",
            "lecture_end_date": "2022-10-15T07:30:00",
            "qr_code_validity": "2023-01-17T17:01:06",
            "lecture_name": "Fundamental of CS",
            "lecture_start_date": "2022-10-15T06:30:00",
            "lecture_id": 1,
            "room_code": "R-201",
            "course_code": "CS-102",
            "lecture_code": "L-C102",
            "teacher_name": "fields"
        },
        "total_absent": 0
    },
    "result": "success"
}
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


{
    "data": "id for attendance id reference 1",
    "result": "success",
    "message": "Success Marked present Note the id and information for future reference",
    "code": 200,
    "i18n_code": "status.mark_present_success"
}

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

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut