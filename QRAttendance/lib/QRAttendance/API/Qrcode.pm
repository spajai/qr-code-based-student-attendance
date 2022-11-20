package QRAttendance::API::Qrcode;
use QRAttendance::Policy;
use QRAttendance::Logger;
use QRAttendance::Utils;
use QRAttendance::DB::Utils;

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
sub qr_check_in {
    my ($self, $qrcode, $user_id) = @_;

    my $log = QRAttendance::Logger->global();
    my $utils = $self->utils;

    my $db_data = $self->db_utils->fetch_row_hashref({
        query => q/
                select 
                    * 
                from  qrcode  qr
                join attendances a on qr.lecture_id = a.lecture_id and is_delete is false and user_id = ?
                where extract(epoch from now())::INT < expiry_epoch and code='?'
                and a.present is false
            /,
       binds => [$qrcode, $user_id]
    });

    # my $response;
    # if(defined $db_data) {
    #     $log->warn("SKIPPING Lecture already scheduled");
    #     $response = {
    #         result => 'error',
    #         error  => 'lecture_already_scheduled',
    #     };
    #     return $response;
    # }

    # my $lecture_create_data = {};
    # foreach (qw/name lecture_code room_code course_code user_id start_timestamp/) {
    #     $lecture_create_data->{$_} = $data->{$_};
    # }

    # my $lecture_data_json = $utils->enc_json($lecture_create_data);

    # $log->info("Trying to create lecture with data $lecture_data_json\n");
    # try {
    #     my $insert_result = $self->db_utils->fetch_row_hashref(
    #         {
    #             query => 'SELECT * FROM register_lecture(?) as ins_result',
    #             binds => [$lecture_data_json],
    #         }
    #     );
    #     if ( defined $insert_result->{ins_result} ) {
    #         my $res_json = JSON::XS->new->decode( $insert_result->{ins_result} );
    #             $log->info("lecture created $insert_result->{ins_result}");
    #             $response = {
    #                 result  => 'success',
    #                 message => 'lecture_success',
    #                 data    => $res_json
    #             };
    #     }
    #     else {
    #         $log->error("Unable to create lecture");
    #         die "Unable to create lecture";
    #     }
    # } catch {
    #     $response = {
    #         result => 'error',
    #         error  => 'data_base_error'
    #     };
    #     $log->error("Error Unable to create lecture in database error". $_);
    # };

    # return $response;
}

