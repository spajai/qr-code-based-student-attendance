package QRAttendance::Controller::Lecture;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller'; }
__PACKAGE__->config->{namespace} = 'api/v1';

use QRAttendance::API::Lecture;
use QRAttendance::Utils;

has 'lecture_api' => (
    is            => 'ro',
    isa           => 'QRAttendance::API::Lecture',
    default       => sub { QRAttendance::API::Lecture->new },
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

=pod
    type schedule_lecture POST
    api schedule-lecture 
    input Body content json needed
    used to schedule lecture


    required keys name lecture_code room_code course_code user_id start_timestamp


    returns JSON

    sample

    {
    "message": "Success lecture scheduled kindly Note the qr code and information for future reference",
    "result": "success",
    "data": {
        "qr_code": "bde1b739-b74d-47a2-9023-dc307bed02af",
        "inserted_lecture_id": 1,
        "attendance_ids": [
            1
        ],
        "qr_id": 1
    },
    "i18n_code": "status.lecture_success",
    "code": 200
}


=cut
sub schedule_lecture : POST Path('schedule-lecture') Args() Does('CheckUrlPermission') {
    my ( $self, $c ) = @_;

    my $post_params         = $c->req->body_data;
    $post_params->{user_id} =  $c->stash->{session_user_id};

    my ($valid, $err) = $self->utils->validate($post_params,[qw/name lecture_code room_code course_code user_id start_timestamp/]);
    if(!$valid) {
        $c->stash->{data} = {
            result     => 'error',
            error      => 'required_param_missing',
            data       => "Missing required attr ". join (',', @$err)
        };
        return;
    }

    my $res = $self->lecture_api->create_lecture($post_params);
    $c->stash->{data} = $res;
    return;
}

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut