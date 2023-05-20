#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

use QRAttendance::API::Lecture;

use QRAttendance::Utils;

our $count = 0;
# test lecture schedule success
note("test lecture schedule success");

{
    local *QRAttendance::DB::Utils::fetch_row_hashref = sub {
        my ($self, $data) = @_;
        if($count == 0) {
            is(scalar @_, 2 ,"Right number of param received");
            ok(1, "Mocked DB util called");
            is_deeply( 
                $data->{binds},
                [ 'L-C102', 'R-201', 'CS-102', '10-15-2022 01:00:00' ],
                "Correct Parameter received"
            );
            $count++;
            return undef;
        }
        if($count == 1) {
            is(scalar @_, 2 ,"Right number of param received");
            ok(1, "Mocked DB util called");
            return {ins_result => '{"ins_result":{"id":1}}'};
        }

    };
    my $lecture_obj = QRAttendance::API::Lecture->new;
    my $res = $lecture_obj->create_lecture({
        "name"               => "Fundamental of CS",
        "lecture_code"       => "L-C102",
        "room_code"          => "R-201",
        "course_code"        => "CS-102",
        "start_timestamp"    => "10-15-2022 01:00:00"
    });
    is_deeply(
        $res,
        {
            'message' => 'lecture_success',
            'data' => {
                'ins_result' => {'id' => 1}
            },
            'result' => 'success'
        },
         "got epected bahviour success"
    );
}

done_testing();
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut