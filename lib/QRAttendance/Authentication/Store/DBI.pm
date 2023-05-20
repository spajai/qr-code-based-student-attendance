package QRAttendance::Authentication::Store::DBI;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

BEGIN {
    __PACKAGE__->mk_accessors(qw/config/);
}

sub new {
    my ( $class, $config, $app) = @_;

    $config->{'store_user_class'} = "QRAttendance::Authentication::Store::DBI::User";

    ## make sure the store class is loaded.
    Catalyst::Utils::ensure_class_loaded( $config->{'store_user_class'} );

    bless { config => $config }, $class;
}

sub from_session {
    my ( $self, $c, $frozenuser ) = @_;

    my $user = $self->config->{'store_user_class'}->new($self->{'config'}, $c);
    return $user->from_session($frozenuser, $c);
}

sub for_session {
    my ( $self, $c, $user ) = @_;

    return $user->for_session($c);
}


sub find_user {
    my ( $self, $authinfo, $c ) = @_;

    my $user = $self->config->{'store_user_class'}->new($self->{'config'}, $c);
 
    return $user->find_user($authinfo, $c);
}

sub user_supports {
    my $self = shift;
    # this can work as a class method on the user class
    $self->config->{'store_user_class'}->supports( @_ );
}

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut