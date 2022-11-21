#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use JSON;
use Catalyst::Test 'QRAttendance';

ok( request('/login')->is_success, 'Request should succeed' );


ok( request('/api/v1/schedule-lecture')->is_success, 'Request should succeed' );
ok( request('/api/v1/qr-info')->is_success, 'Request should succeed' );
ok( request('/api/v1/verify_login')->is_success, 'Request should succeed' );
ok( request('/api/v1/logout')->is_success, 'Request should succeed' );
ok( request('/api/v1/qr-check-in')->is_success, 'Request should succeed' );


use HTTP::Request::Common;
my $response = request POST '/api/v1/qr-check-in', [];
like( $response->content, qr/Error 404/ );

my $response = request POST '/login', [ username => 'invalid', password => 'invalid'];
like( $response->content, qr/Error in Login invalid login credential/ );


my $response = request POST '/api/v1/schedule-lecture', [ room_code => 'invalid'];
like( $response->content, qr/Unauthorized Need login/ );

my $response = request POST '/login', {"username" => "dsmith", "password" => "d.smith!"};
my $rs = JSON::decode_json('{"result" : "success","code" : 200,"message" : "Login Success"}');
is_deeply( JSON::decode_json($response->decoded_content), $rs);

done_testing();

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut