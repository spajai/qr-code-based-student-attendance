package QRAttendance::API::Lecture;
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
# modules needed
use QRAttendance::Policy;
use QRAttendance::Logger;
use QRAttendance::Utils;
use QRAttendance::DB::Utils;
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

has 'utils' => (
    is            => 'ro',
    isa           => 'QRAttendance::Utils',
    default       => sub { QRAttendance::Utils->new },
    lazy          => 1
);
has 'db_utils' => (
    is            => 'ro',
    isa           => 'QRAttendance::DB::Utils',
    default       => sub { QRAttendance::DB::Utils->new },
    lazy          => 1
);
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

=pod
#----------------------------------------------------------------------------------#
# used to create lecture
#   sub create_lecture
# 
        inp :
            invocant
            data hashref madatory keys (name lecture_code room_code course_code user_id start_timestamp)
        Return :
        for error
        {
            result => 'error', 
            error  => 'lecture_already_scheduled',
        }
        for success
            {
                result  => 'success',
                message => 'lecture_success',
                data    => $res_json
            };

#
#----------------------------------------------------------------------------------#
=cut
sub create_lecture {
    my ($self, $data) = @_;

    my $log = QRAttendance::Logger->global();
    my $utils = $self->utils;

    my $db_data = $self->db_utils->fetch_row_hashref({
        query => q/
                select * from lectures 
                    where 
                        code = ? 
                    and room_id = (select id from rooms where code = ?) 
                    and course_id = (select id from courses where code = ?)
                    and (select to_timestamp(start_epoch))::date = (?)::date
            /,
       binds => [$data->{lecture_code}, $data->{room_code}, $data->{course_code}, $data->{start_timestamp}]
    });

    my $response;
    if(defined $db_data) {
        $log->warn("SKIPPING Lecture already scheduled");
        $response = {
            result => 'error',
            error  => 'lecture_already_scheduled',
        };
        return $response;
    }

    my $lecture_create_data = {};
    foreach (qw/name lecture_code room_code course_code user_id start_timestamp/) {
        $lecture_create_data->{$_} = $data->{$_};
    }

    my $lecture_data_json = $utils->enc_json($lecture_create_data);

    $log->info("Trying to create lecture with data $lecture_data_json\n");
    try {
        my $insert_result = $self->db_utils->fetch_row_hashref(
            {
                query => 'SELECT * FROM register_lecture(?) as ins_result',
                binds => [$lecture_data_json],
            }
        );

        if ( defined $insert_result->{ins_result} ) {
            my $res_json = $utils->dcd_json( $insert_result->{ins_result} );
                $log->info("lecture created $insert_result->{ins_result}");
                $response = {
                    result  => 'success',
                    message => 'lecture_success',
                    data    => $res_json
                };
        }
        else {
            $log->error("Unable to create lecture");
            die "Unable to create lecture";
        }
    } catch {
        $response = {
            result => 'error',
            error  => 'data_base_error'
        };
        $log->error("Error Unable to create lecture in database error". $_);
    };

    return $response;
}

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut