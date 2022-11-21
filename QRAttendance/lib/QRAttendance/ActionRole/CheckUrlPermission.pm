package QRAttendance::ActionRole::CheckUrlPermission;

use QRAttendance::Policy qw( role );
use QRAttendance::Logger;

around execute => sub {
    my $orig = shift;
    my $self = shift;
    my ( $controller, $c ) = @_;

    my $params;
    my $logger = QRAttendance::Logger->global();
    ###################################
    # for all user                   ##
    ####################################
    if (!defined $c->user ) {
        # $c->log->error("User object not found. User Not Logged In");
         $logger->error("User object not found. User Not Logged In");
        $c->stash->{data} = {
            code      => 401,
            result   => 'error',
            message  => 'Unauthorized Need login',
        };
        # $c->res->redirect('/login');
        $c->detach;
    }

    my $user_id = $c->user->user_id;
    $c->stash->{user_permission}     =  $c->session->{$user_id}{user_url_permission};
    $c->stash->{session_user_id}     =  $user_id;
    $c->stash->{session_user_type}   =  $c->user->type;

    if(! defined $c->stash->{user_permission}) {
        $logger->error("User Dont have permission");
        $c->log->error("User don't have roles permission");
        $c->res->redirect('/login');
        $c->detach;
    }


    if(! check_permission($c)){
        $logger->error("User Dont have permission");
        $c->log->error("User don't have url permission");
        # user may have mistakeny edited url 
        # keep session
        $c->stash->{data} = {
            code      => 401,
            result   => 'error',
            message  => 'user Dont have permission to access this url',
        };

        # $c->error('user dont have permission to access URL');
        $c->detach();
        # croak "user dont have permission";
        # log error
    }

    return $self->$orig(@_);
};


sub check_permission {
    my ( $c ) = @_;

    my $req_data = $c->stash->{internal}{request_metadata};
    my $username = $c->user->username;
    my $user_id = $c->user->user_id;
    my $user_type = $c->user->type;

    # will stash the permission
    my $permissions = $c->{stash}->{user_permission};
    if ( defined $permissions ) {

        # Teacher#API#DELETE#/api/v1/attendance'
        my $type        = $c->stash->{is_api} ? 'API' : 'UI';
        my $req_url_str = $user_type . '#'. $type . '#' . $req_data->{method} . '#' . $req_data->{url_path};
        if ( !$permissions->{$req_url_str} ) {
            $c->log->error("User ($username)[$user_id] don't have permissions to access url '$req_url_str'");
            return;
        }
        else {
            $c->log->debug("URL => $req_url_str permission granted for User => ($username)[$user_id]");
            return 1;
        }
    }

    return;
}


1;

__END__
=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut