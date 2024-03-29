package QRAttendance::Authentication::Credential::Password;
use Moose;
use namespace::autoclean;

with 'MooseX::Emulate::Class::Accessor::Fast';
use QRAttendance::API::Login;

__PACKAGE__->mk_accessors(qw/_config realm/);

sub new {
    my ($class, $config, $app, $realm) = @_;
    
    my $self = { _config => $config };
    bless $self, $class;

    $self->realm($realm);

    return $self;
}

sub authenticate {
    my ( $self, $c, $realm, $authinfo ) = @_;

    my $login_params = {username => $authinfo->{username}};

    my $login_api = QRAttendance::API::Login->new();
    my $user_obj = $realm->find_user($login_params, $c);

    if (defined $user_obj && ref($user_obj)) {
        if ($self->check_password($user_obj, $authinfo, $login_api)) {
            my $user_id =  $user_obj->user_id;
            $c->log->info("UserName ($authinfo->{username})[$user_id] logged in successfully user info fetched");
            my $sess = $c->session;
            if(! defined $sess->{$user_id}{user_url_permission} ) {
                $sess->{$user_id}{user_url_permission} = $login_api->get_user_url_permission( $user_id );
                $c->log->info("UserName ($authinfo->{username})[$user_id] url_permission set successfully");
            }
            return $user_obj;
        } else {
            $c->log->error("Invalid password for UserName ($authinfo->{username}) unable to login");
        }
    } else {
        $c->log->error("UserName $authinfo->{username} not found unable to login");
    }

    return;
}

sub check_password {
    my ( $self, $user_obj, $authinfo, $login_api ) = @_;
    # delete @{$user_db_data}{qw/password password_hash_algorithm password_salt/};
    my $password = $authinfo->{password};
    my $storedpassword = $user_obj->get('password');

    return $login_api->check_password($storedpassword, $password);
}

1;

# __PACKAGE__;

__END__

=pod

=head1 NAME

QRAttendance::Authentication::Credential::Password - Authenticate a user
with a password.

=head1 SYNOPSIS

    use Catalyst qw/
      Authentication
      /;

    package MyApp::Controller::Auth;

    sub login : Local {
        my ( $self, $c ) = @_;

        $c->authenticate( { username => $c->req->param('username'),
                            password => $c->req->param('password') });
    }

=head1 DESCRIPTION

This authentication credential checker takes authentication information
(most often a username) and a password, and attempts to validate the password
provided against the user retrieved from the store.

=head1 CONFIGURATION

    # example
    __PACKAGE__->config('Plugin::Authentication' =>
                {
                    default_realm => 'members',
                    realms => {
                        members => {

                            credential => {
                                class => 'Password',
                                password_field => 'password',
                                password_type => 'hashed',
                                password_hash_type => 'SHA-1'
                            },
                            ...


The password module is capable of working with several different password
encryption/hashing algorithms. The one the module uses is determined by the
credential configuration.

Those who have used L<Catalyst::Plugin::Authentication> prior to the 0.10 release
should note that the password field and type information is no longer part
of the store configuration and is now part of the Password credential configuration.

=over 4

=item class

The classname used for Credential. This is part of
L<Catalyst::Plugin::Authentication> and is the method by which
Catalyst::Authentication::Credential::Password is loaded as the
credential validator. For this module to be used, this must be set to
'Password'.

=item password_field

The field in the user object that contains the password. This will vary
depending on the storage class used, but is most likely something like
'password'. In fact, this is so common that if this is left out of the config,
it defaults to 'password'. This field is obtained from the user object using
the get() method. Essentially: $user->get('passwordfieldname');
B<NOTE> If the password_field is something other than 'password', you must
be sure to use that same field name when calling $c->authenticate().

=item password_type

This sets the password type.  Often passwords are stored in crypted or hashed
formats.  In order for the password module to verify the plaintext password
passed in, it must be told what format the password will be in when it is retreived
from the user object. The supported options are:

=over 8

=item none

No password check is done. An attempt is made to retrieve the user based on
the information provided in the $c->authenticate() call. If a user is found,
authentication is considered to be successful.

=item clear

The password in user is in clear text and will be compared directly.

=item self_check

This option indicates that the password should be passed to the check_password()
routine on the user object returned from the store.

=item crypted

The password in user is in UNIX crypt hashed format.

=item salted_hash

The password in user is in salted hash format, and will be validated
using L<Crypt::SaltedHash>.  If this password type is selected, you should
also provide the B<password_salt_len> config element to define the salt length.

=item hashed

If the user object supports hashed passwords, they will be used in conjunction
with L<Digest>. The following config elements affect the hashed configuration:

=over 8

=item password_hash_type

The hash type used, passed directly to L<Digest/new>.

=item password_pre_salt

Any pre-salt data to be passed to L<Digest/add> before processing the password.

=item password_post_salt

Any post-salt data to be passed to L<Digest/add> after processing the password.

=back

=back

=back

=head1 USAGE

The Password credential module is very simple to use. Once configured as
indicated above, authenticating using this module is simply a matter of
calling $c->authenticate() with an authinfo hashref that includes the
B<password> element. The password element should contain the password supplied
by the user to be authenticated, in clear text. The other information supplied
in the auth hash is ignored by the Password module, and simply passed to the
auth store to be used to retrieve the user. An example call follows:

    if ($c->authenticate({ username => $username,
                           password => $password} )) {
        # authentication successful
    } else {
        # authentication failed
    }

=head1 METHODS

There are no publicly exported routines in the Password module (or indeed in
most credential modules.)  However, below is a description of the routines
required by L<Catalyst::Plugin::Authentication> for all credential modules.

=head2 new( $config, $app, $realm )

Instantiate a new Password object using the configuration hash provided in
$config. A reference to the application is provided as the second argument.
Note to credential module authors: new() is called during the application's
plugin setup phase, which is before the application specific controllers are
loaded. The practical upshot of this is that things like $c->model(...) will
not function as expected.

=head2 authenticate( $authinfo, $c )

Try to log a user in, receives a hashref containing authentication information
as the first argument, and the current context as the second.

=head2 check_password( )

=cut
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut