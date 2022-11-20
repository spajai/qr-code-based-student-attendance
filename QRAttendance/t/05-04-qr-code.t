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

#successful  attendances
note("successful  attendances by qr code scan");

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
            return {id => 11, lecture_id => 21};
        }
        if($count == 1) {
            is(scalar @_, 2 ,"Right number of param received");
            ok(1, "Mocked DB util called");
            is_deeply( 
                $data->{binds},
                [ '1','11' ],
                "Correct Parameter received"
            );
            $count++;
            return {id => 1};
        }
        if($count == 2) {
            is(scalar @_, 2 ,"Right number of param received");
            ok(1, "Mocked DB util called");
            is_deeply( 
                $data->{binds},
                [ '1','21' ],
                "Correct Parameter received"
            );
            $count++;
            return {id => 1};
        }

    };
    local *QRAttendance::DB::Utils::update = sub {
        my ($self, $data) = @_;
        is(scalar @_, 2 ,"Right number of param received");
        ok(1, "Mocked DB util called");
                is_deeply( 
                $data,
                {
                'returning' => {
                                'returning' => '"id"'
                                },
                'update_val' => {
                                    'present' => 1
                                },
                'table' => 'attendances',
                'where_hash' => {
                                    'lecture_id' => 21,
                                    'user_id' => 1,
                                    'id' => 1
                                }
                },
                "Correct Parameter received"
            );
        return 1;
    };
    my $qr_obj = QRAttendance::API::Qrcode->new;
    my $res = $qr_obj->qr_check_in('bde1b739-b74d-47a2-9023-dc307bed02af',1);

    is_deeply(
        $res,
        {
                result  => 'success',
                message => 'mark_present_success',
                data    =>  "id for attendance id reference 1"
        },
     "got epected bahviour"
    );
}

done_testing();
