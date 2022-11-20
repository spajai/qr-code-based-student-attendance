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

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

#get all stats 
    # total attendance class wise
    # % of attendance   class wise
# attennce by student wise
    # total classes
    # every class and %total








# sub get_class_room_code : GET Path('class-rooms') Args(1) Does('CheckUrlPermission') {
#     my ($self, $c, $class_room_code) = @_;

#     if( ! defined $class_room_code or $class_room_code !~ /^CR/) {
#         $c->stash->{data} = {result => 'error', error => 'body_decode_error'};
#         $c->log->error("Error ClassRoom code is required found invalid code ". $class_room_code);
#         return;
#     }

#     my $result = $self->class_room_api->get_class_room_list($class_room_code);

#     $c->stash->{data} = $result;

#     return;
# }

__PACKAGE__->meta->make_immutable;

1;