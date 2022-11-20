package QRAttendance::Controller::API::Dashboard;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config->{namespace} = 'api/v1';

use QRAttendance::API::Dashboard;

#----------------------------------------------------------------------------------#
# custom module LOGIN                                                              #
#----------------------------------------------------------------------------------#
has 'class_room_api' => (
    is            => 'ro',
    isa           => 'QRAttendance::API::Dashboard',
    default       => sub { QRAttendance::API::Dashboard->new },
    lazy          => 1
);
