package QRAttendance::API::Login;

use QRAttendance::Policy;
use QRAttendance::Logger;
use QRAttendance::DB::Utils;
use QRAttendance::Utils;
use QRAttendance::Password::argon2;

#---------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#check user and hashpassword
# check manually if present in db
# above true then let him login and
# create session for user save 
has 'db_utils' => (
    is            => 'ro',
    isa           => 'QRAttendance::DB::Utils',
    default       => sub { QRAttendance::DB::Utils->new },
    lazy          => 1
);
has 'utils' => (
    is            => 'ro',
    isa           => 'QRAttendance::Utils',
    default       => sub { QRAttendance::Utils->new },
    lazy          => 1
);
has 'entropy_obj' => (
    is            => 'ro',
    isa           => 'QRAttendance::Password::argon2',
    default       => sub { QRAttendance::Password::argon2->new },
    lazy          => 1
);


sub login {
    my ($self, $user_data) = @_;
    my $username = $user_data->{username};
    my $password = $user_data->{password};

    #self default error
    my $result = $self->_unauthorized('UserName or Password does not match');
    #check login
     $result = $self->find_user_login( $username);

    if(defined $result && $result->{result} eq 'success') {
        #will delete the password hash
        my $pass_result = $self->check_password($result->{data}, $password);
        #if wrong pass else return result
        if($pass_result->{result} ne 'success') {
            $result = $self->_unauthorized('UserName or Password does not match');
        }
    }

    return $result;
}

sub find_user_login {
    my ($self, $params) = @_;

    my $username = $params->{username};

    my $log = QRAttendance::Logger->global();
    my $result;

    if (!(defined $username)) {
        $log->error("UserName not sent");
        $result = $self->_unauthorized('UserName or Password not Provided');
        return $result;
    }

    try {
        # my $user_db_data = $self->db_utils->get_login_user_data({username => $username});

        my $sql = "select *, id as user_id from users where username = ? and is_deleted is false";
        my $user_db_data = $self->db_utils->fetch_row_hashref({ query => $sql, binds => [$username] });


        if(! defined $user_db_data) {
            $log->error("UserName $username not found or deleted in database");
            $result = $self->_unauthorized('UserName not found');
            return $result;
        }
        #valid user found 
         $result = {
            result => 'success',
            message => 'Valid user',
            data => $user_db_data
        };
    } catch {
       $log->error("Error occured find_user_login while verifying credentials $_");
       $result = {
            result => 'error',
            error  => 'internal_server_error',
            message => 'Internal db error'
        };
    };

    return $result;
}


sub check_password {
    my ($self, $hashed_pass, $plain_pass) = @_;

    #check password
    my $pass_verify = $self->entropy_obj->verify_password_hash($hashed_pass, $plain_pass);

    return  (defined $pass_verify &&  $pass_verify) ? 1 : 0;
}

sub _unauthorized {
    my ($self, $message) = @_;
    return {
        result => 'error',
        error  => 'unauthorized',
        message => $message
    };
}


sub get_user_url_permission {
    my ($self, $user_id) = @_;

    return undef unless (defined $user_id);

    my $sql = "select * from user_url_permissions(?) as result";
    my $user_url_data = $self->db_utils->fetch_row_hashref({ query => $sql, binds => [$user_id] });

    if(defined $user_url_data && defined $user_url_data->{result}) {
        my $res =  $self->utils->dcd_json($user_url_data->{result});
        my $url_map;
        if(scalar @$res) {
            foreach (@{$res->[0]->{url_type_permissions}}) {
                $url_map->{$_} = 1;
            }
        }

        return $url_map;

    } else {
        return;
    }

}

1;
