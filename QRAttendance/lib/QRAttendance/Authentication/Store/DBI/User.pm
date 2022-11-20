package QRAttendance::Authentication::Store::DBI::User;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Authentication::User';
with 'MooseX::Emulate::Class::Accessor::Fast';

use List::MoreUtils 'all';
use QRAttendance::API::Login;

__PACKAGE__->mk_accessors( qw /config _user _role/ );

sub new {
    my ( $class, $config, $c ) = @_;
    return bless { config => $config }, $class;
}
 
sub find_user {
    my ( $self, $userinfo, $c ) = @_;

    my $user_store_data = $self->_find_user($userinfo, $c) // undef;
    if ($user_store_data) {
        $self->_user($user_store_data);
        return $self;
    }

    return;
}

sub role_permission {
    my ( $self ) = @_;

    return $self->_user->{roles};
}

sub get {
    my ($self, $field) = @_;
 
    if ($self->_user) {
        return $self->_user->{$field};
    }

    return;
}

sub supported_features {
    my $self = shift;
 
    return {
        session         => 1,
        roles           => 1,
    };
}

sub id {
    my $self = shift;

    $self->_user->{username};
}

sub _find_user {
    my ($self, $userinfo, $c ) = @_;

    my $login_api = QRAttendance::API::Login->new();

    my $params;
    if ($c->stash->{req}->{body_data}) {
        $params = $c->stash->{req}->{body_data};
    }

    my $result;
    # TODO: Find a way to escape backend script
     if ($params && defined $params->{script_api_user}) {
         $c->log->warn("Script/Api User detected in request ($params->{script_api_user})");
        $result = $login_api->find_system_login({username => $params->{script_api_user}});
     } else {
        $result = $login_api->find_user_login($userinfo);
        $c->log->info("Checking user $userinfo->{username} in database");
     }

    if(defined $result) {
        if($result->{result} eq 'success') {
            my $username = $userinfo->{username};
            #cache for session
            $c->log->info("user $userinfo->{username} Found in database");

            $self->_user({$username => $result->{data}});
            return $result->{data};
        } elsif($result->{result} eq 'error') {
            #avoid modifying the $c in store
            #TODO <<<<>>>>
            $c->stash->{data} = $result;
        }
    }

    return;
}

sub for_session {
    my ( $self, $c, $user ) = @_;

    return $self->_user;
}

sub from_session {
    my ( $self, $frozenuser, $c ) = @_;

    if ($self->_user) {
        return $self->_user;
    }

    my $username = $frozenuser->{username};
    return $self->find_user({username => $frozenuser->{username}}, $c);
}

sub AUTOLOAD {
    my $self = shift;

    my $method = our $AUTOLOAD;
	$method =~ s/.*:://;
  
    return if $method eq "DESTROY";
    return $self->$method(@_) if ($self->can($method));
  
    if (exists $self->{_user}{$method}) {
        return $self->{_user}{$method};
    }
    else {
        die __PACKAGE__ . ": Method($method) not found\n";
    }
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;