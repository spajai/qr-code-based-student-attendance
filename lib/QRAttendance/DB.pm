package QRAttendance::DB;

use QRAttendance::Policy;
use DBIx::Connector;

#----------------------------------------------------------------------------------#
# custom module for all Utils                                                      #
#----------------------------------------------------------------------------------#
use QRAttendance::Utils;
use vars qw( $CACHED_DBI );
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#

has 'db_conf' => (
    is            => 'ro',
    isa           => 'HashRef',
    default       => sub {
        {
            port           => $ENV{PGPORT} // 5432,
            dbname         => $ENV{PGDATABASE} // 'qrattendance',
            host           => $ENV{PGHOST} // 'localhost',
            username       => $ENV{PGUSER} // 'sushrut',
            password       => $ENV{PGPASSWORD} // 'sushrut',
        },
     },
    lazy          => 1,
);

=pod
#----------------------------------------------------------------------------------#
# create the connection using the DBIX connector return cached connection .
# if requested again before returning the cache conn make sure its live connection.
#----------------------------------------------------------------------------------#
=cut

sub get_dbi_db_con {
    my ($self) = @_;

    if ( defined $CACHED_DBI && $CACHED_DBI->{dbh}->ping ) {

        # return live connection
        warn ">>>>>>>>>>>> Returning cached live connection <<<<<<<<<";
        return $CACHED_DBI;
    }

    my $conf    = $self->db_conf;
    my $dbi_opt = $conf->{dbi_opt} // {};

    if ( (defined $conf->{dbname} && defined $conf->{username} && defined $conf->{password}) || defined $conf->{service}) {

        my @opt;
        if (defined $conf->{service} ) {
            @opt = ( 'dbi:Pg:service=' . $conf->{service}, '', '' );
        }
        else {
            my $dsn = 'dbi:Pg:dbname=' . $conf->{dbname};
            $dsn .= ';host=' . $conf->{host} if ( $conf->{host} );
            $dsn .= ';port=' . $conf->{port} if ( $conf->{port} );
            @opt = ( $dsn, $conf->{username}, $conf->{password} );
        }

        try {
            # Create a connection.
            my $dbi = DBIx::Connector->new(
                @opt,
                {
                    RaiseError => 1,
                    AutoCommit => 1,
                    %{$dbi_opt},
                }
            );

            #test
            $dbi->dbh->ping;
            $CACHED_DBI->{conn} = $dbi;
            $CACHED_DBI->{dbh}  = $dbi->dbh;
        } catch {
            croak ": Error occured while connecting to db using dbi :" . $_;
        };

        return $CACHED_DBI;
    }
    else {
        croak ": Error occured while connecting to db using dbi conncetion parameters missing :";
    }

}

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut