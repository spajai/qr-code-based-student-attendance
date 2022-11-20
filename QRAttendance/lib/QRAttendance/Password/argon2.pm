package QRAttendance::Password::argon2;

use QRAttendance::Policy;

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
use Crypt::Argon2 qw(argon2id_pass argon2id_verify);
use Crypt::PRNG;

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
use Readonly;
Readonly my $HASH_LEGTH => 24;

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
has 'config' => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub {
        {
            t_cost      => 4,        # cost/iteration
            m_factor    => '32M',    # ram to use
            parallelism => 1,        # parallelism
            salt_len    => 24        # salt_lenth
        };
    },
    required      => 1,
    documentation => 'This will have default config used by the argon2',
);

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
has 'random' => (is => 'ro', isa => 'Crypt::PRNG', default => sub { Crypt::PRNG->new }, lazy => 1,);

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

sub get_password_hash {
    my ($self, $password) = @_;

    if (not defined $self->config) {
        croak 'Should be invoke via object';
    }
    my $config = $self->config;

    my $salt = $self->random->bytes($config->{salt_len});

    my $get_legth = $HASH_LEGTH;    #tag_size
    my @args = ($password, $salt, $config->{t_cost}, $config->{m_factor}, $config->{parallelism}, $get_legth,);

    my $pass_hash = argon2id_pass(@args);

    return $pass_hash;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub verify_password_hash {
    my ($self, $password_hash, $password) = @_;

    #will accept the password encoded from this module only
    my $result = argon2id_verify($password_hash, $password);

    return $result;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
__PACKAGE__->meta->make_immutable;

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

1;