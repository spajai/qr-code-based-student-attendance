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
=pod
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------##
qr_check_in 
        used to mark attendance_marked_or_invalid

        input qrcode

        checks:

             Invalid QR code or Expired
             QR code has been expired
             QR code do not belong to user 
             Already Marked Present"

    output 
        success
        {
                result  => 'success',
                message => 'mark_present_success',
                data    =>  "id for attendance id reference ". $db_data->{id}
        };

    or error 
    
        {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => qq/Invalid Request There could be several reason 
                        1. Invalid QR code or Expired
                        2. QR code has been expired/
        }

        or 

        {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => "Invalid Request There could be several reason \n1. QR code do not belong to user \n2. Already Marked Present"
        };

        or 

        {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => "Invalid Request There could be several reason\n 1. There is no class scheduled today for the scanning user (Make sure using the valid student account)"
        }
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
=cut
sub qr_check_in {
    my ($self, $qrcode, $user_id) = @_;

    my $log = QRAttendance::Logger->global();
    my $utils = $self->utils;
    my $qr_data = $self->db_utils->fetch_row_hashref({
        query => q/select * from qrcode where code = ? AND  extract(epoch from now())::INT < expiry_epoch/,
        binds => [$qrcode]
    });
    my $response;
    if(not defined $qr_data) {
        $log->error("Invalid or expired qr code $qrcode , user_id $user_id ");
        $response = {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => qq/Invalid Request There could be several reason 
                        1. Invalid QR code or Expired
                        2. QR code has been expired/
        };
        return $response;
    }

    my $db_data = $self->db_utils->fetch_row_hashref({
        query => q/
                select 
                    a.*
                from qrcode  qr
                join attendances a on qr.lecture_id = a.lecture_id and a.is_deleted is false and a.user_id = ?
                where 
                   qr.id = ?
            /,
       binds => [ $user_id, $qr_data->{id} ]
    });

    if(! defined $db_data || (defined $db_data && $db_data->{present}) ) {
        $log->warn("SKIPPING data not found qr $qrcode , user_id $user_id ");
        $response = {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => "Invalid Request There could be several reason \n1. QR code do not belong to user \n2. Already Marked Present"
        };
        return $response;
    }

    my $student_data = $self->db_utils->fetch_row_hashref({
        query => q/
                select
                    a.*
                from attendances a
                where
                   user_id  = ?  and
                   lecture_id = ?  and
                   (current_date)::date = date::date
                   
            /,
       binds => [ $user_id, $qr_data->{lecture_id} ]
    });

    if(not defined $student_data ) {
        $log->warn("SKIPPING student dont have lecture scheduled today $qrcode , user_id $user_id , lecture id $qr_data->{lecture_id}");
        $response = {
            result => 'error',
            error  => 'attendance_marked_or_invalid',
            data   => "Invalid Request There could be several reason\n 1. There is no class scheduled today for the scanning user (Make sure using the valid student account)"
        };
        return $response;
    }


    $log->info("Trying to mark present qr $qrcode , user_id $user_id\n");
    try {
        # table update_val where_hash/
        my $result = $self->db_utils->update({
            table       => 'attendances',
            update_val  => { present => 1},
            where_hash  => { id => $db_data->{id}, user_id => $user_id, lecture_id => $qr_data->{lecture_id} },
            returning   => { returning => '"id"' }
        });
        if ($result) {
            $log->info("marked prsent attendance id $db_data->{id}");
            $response = {
                result  => 'success',
                message => 'mark_present_success',
                data    =>  "id for attendance id reference ". $db_data->{id}
            };
        }
        else {
            $log->error("Unable to mark present");
            die "Unable to mark present";
        }
    } catch {
        $response = {
            result => 'error',
            error  => 'data_base_error'
        };
        $log->error("Error Unable to mark present database error". $_);
    };

    return $response;
}

#----------------------------------------------------------------------------------#
# used to get complete details of the qrcode
# qr_info
#  input qr code (mandatory)
#--output
    #    return {
    #     result  => 'success',
    #     message => 'qr_data_fetched',
    #     data    =>  $qr_data 
    # };
#----------------------------------------------------------------------------------#

sub qr_info {
    my ($self, $qrcode) = @_;

    my $qr_data = $self->db_utils->fetch_row_hashref({
        query => q/select result from qr_data_vw where qr_code = ?/,
        binds => [$qrcode]
    }) // {};

    #decode the json
    if(defined $qr_data && defined $qr_data->{result}) {
        $qr_data = $self->utils->dcd_json($qr_data->{result});
    }

    return {
        result  => 'success',
        message => 'qr_data_fetched',
        data    =>  $qr_data 
    };

}

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut