package QRAttendance::Controller::API::ClassRoom;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller'; }

__PACKAGE__->config->{namespace} = 'api/v1';

use QRAttendance::API::ClassRoom;

#----------------------------------------------------------------------------------#
# custom module LOGIN                                                              #
#----------------------------------------------------------------------------------#
has 'class_room_api' => (
    is            => 'ro',
    isa           => 'QRAttendance::API::ClassRoom',
    default       => sub { QRAttendance::API::ClassRoom->new },
    lazy          => 1
);

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
# 
sub get_class_room_code : GET Path('class-rooms') Args(1) Does('CheckUrlPermission') {
    # my ($self, $c, $class_room_code) = @_;

    # if( ! defined $class_room_code or $class_room_code !~ /^CR/) {
    #     $c->stash->{data} = {result => 'error', error => 'body_decode_error'};
    #     $c->log->error("Error ClassRoom code is required found invalid code ". $class_room_code);
    #     return;
    # }

    # my $result = $self->class_room_api->get_class_room_list($class_room_code);

    # $c->stash->{data} = $result;

    # return;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut