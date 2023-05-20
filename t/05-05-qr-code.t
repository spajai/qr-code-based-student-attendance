#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QRAttendance::API::Qrcode;

use Data::Dumper;
use QRAttendance::Utils;

#successful  attendances
note("successful qr-code info retrival");

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
            return {result => '{"all_absent_student" : null, "total_absent" : 0, "all_present_student" : ["david smith"], "total_present" : 1, "qr_data" : {"qr_code":"bde1b739-b74d-47a2-9023-dc307bed02af","qr_code_validity":"2023-01-17T17:01:06","lecture_name":"Fundamental of CS","lecture_code":"L-C102","lecture_status":"Scheduled","lecture_start_date":"2022-10-15T06:30:00","lecture_end_date":"2022-10-15T07:30:00","room_code":"R-201","course_name":"Machine Learning","course_code":"CS-102","teacher_name":"fields","lecture_id":1}}'};
        }
    };

    my $qr_obj = QRAttendance::API::Qrcode->new;
    my $res = $qr_obj->qr_info('bde1b739-b74d-47a2-9023-dc307bed02af');

    is_deeply(
        $res,
        {
            result  => 'success',
            message => 'qr_data_fetched',
            'data' => {
                    'all_present_student' => [
                                                'david smith'
                                            ],
                    'total_absent' => 0,
                    'qr_data' => {
                                    'lecture_code' => 'L-C102',
                                    'room_code' => 'R-201',
                                    'course_name' => 'Machine Learning',
                                    'course_code' => 'CS-102',
                                    'lecture_id' => 1,
                                    'lecture_name' => 'Fundamental of CS',
                                    'qr_code_validity' => '2023-01-17T17:01:06',
                                    'teacher_name' => 'fields',
                                    'lecture_status' => 'Scheduled',
                                    'qr_code' => 'bde1b739-b74d-47a2-9023-dc307bed02af',
                                    'lecture_end_date' => '2022-10-15T07:30:00',
                                    'lecture_start_date' => '2022-10-15T06:30:00'
                                },
                    'all_absent_student' => undef,
                    'total_present' => 1
                }
        },
     "got epected bahviour"
    );
}

done_testing();
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut