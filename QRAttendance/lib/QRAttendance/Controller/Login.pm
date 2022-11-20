package QRAttendance::Controller::Login;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller'; }

has 'login_api' => (
    is            => 'ro',
    isa           => 'QRAttendance::API::Login',
    default       => sub { QRAttendance::API::Login->new },
    lazy          => 1
);

sub index : GET Path('') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'login.tt';
    $c->forward('View::HTML');
}

sub verify_login : POST Path('') Args(0)  {
    my ( $self, $c ) = @_;

    my $post_params = $c->req->body_data;

    my $auth = $c->authenticate( {
        username => $post_params->{username},
        password => $post_params->{password}
    });
    my $result;

    if (ref($auth)eq 'QRAttendance::Authentication::Store::DBI::User'){
        $c->log->info(sprintf("User Id: %s , Session %s login tracked", $c->user->get('id'),$c->sessionid));

        $result =  {
            code      => 200,
            result   => 'success',
            message  => 'Login Success',
        };
    } else {
        $result = {
            code      => 401,
            result   => 'error',
            message  => 'Error in Login invalid login credential',
        };
    }

    $c->stash->{data} = $result;
    $c->forward('View::JSON');
}
