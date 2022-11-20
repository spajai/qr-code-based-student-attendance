package QRAttendance::Controller::Root;
use QRAttendance::Policy;

BEGIN { extends 'Catalyst::Controller' }

use Data::Dumper; #in use for debug
use QRAttendance::Response qw(%SERVER_RESPONSE);
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

sub begin : Path {
    my ($self, $c) = @_;
    my $req = $c->request;
    my $result;
    if ($req) {
        my $path = '/' . ($req->match // $req->path_info // $req->path) // $req->env->{REQUEST_URI} // $req->env->{PATH_INFO};
        my $url =  sprintf('%s',$req->uri);

        $result->{url_path}    = $path                    if ($path);
        $result->{method}      = $req->method             if ( $req->method );
        $result->{address}     = $req->address            if ( $req->address );
        $result->{referer}     = $req->referer            if ( $req->referer );
        $result->{uri}         = $url                     if ( $url );
        $result->{user_agent}  = $req->user_agent         if ( $req->user_agent );
    }

    $c->stash->{internal}{request_metadata} = $result;

    # check ip logic
    my $url = $c->req->path;

    if ($url =~ /^api\/v([0-9])/) {
        $c->log->debug("REST api version: $1");
        $c->stash->{is_api}     = 1;
        $c->stash->{current_view} = 'JSON';
    }

    if($c->stash->{is_api}) {
        my @content_type = $c->req->content_type;

        if ($c->req->method =~ /(POST|PUT)/) {
            #try to decode body use the decoded data from stash in all controller
            try {
                $c->stash->{req}->{body_data} = { %{$c->req->body_data}, %{$c->req->parameters} };
            } catch {
                $c->stash->{data} = {result => 'error', error => 'body_decode_error'};
                $c->log->error("Error occured while getting body data". $_ );
                return;
            };
        }

        if($c->req->method eq 'DELETE') {
            # combination of query_parameters and body_parameters.
            $c->stash->{req}->{body_data} = $c->req->parameters;
        }
    }

}

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    if (!$c->user) {
        $c->res->redirect('/login');
    }
    else {
        $c->res->redirect('/dashboard');
    }
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ($self, $c) = @_;

    $c->stash->{template} = '404.tt';
    $c->forward('View::HTML');
}

sub logout : Path('logout') {
    my ($self, $c) = @_;
    $c->delete_session("logout");
    $c->logout();

    $c->res->redirect('/');
}

sub catch_errors : Private {
    my ($self, $c, @errors) = @_;

    # Handle custom error using AudioCast::Role::Exception role
    $self->handle_catch_errors($c, @errors);
}


sub end : ActionClass('RenderView') {
    my ($self, $c) = @_;

    {
        # local $Data::Dumper::Indent = 0;
        # local $Data::Dumper::Terse = 1;
        $c->log->debug("Data in stash " . Dumper($c->stash->{data}));

        if ($c->stash->{is_api}) {
            my $stash_data   = $c->stash->{data};
            my ($response_key,$key);

            if(defined $stash_data && ref $stash_data eq 'HASH') {
                $response_key = $stash_data->{result} eq 'success' ? 'message' : 'error';
                $key          = delete $stash_data->{$response_key};
            } else {
                $response_key = 'error';
            }

            if (defined $key && exists $SERVER_RESPONSE{$key}) {
                $stash_data = {%{$stash_data}, %{$SERVER_RESPONSE{$key}{throw}}};
            } else {
                $c->log->error("API response not found: '$response_key'");
            }

            my $code = $stash_data->{code} // 200;
            $c->stash->{data} = $stash_data;

            $c->response->status($code);
            $c->log->debug("API Setting response " . Dumper($stash_data));
        }
    }

    return;

}
