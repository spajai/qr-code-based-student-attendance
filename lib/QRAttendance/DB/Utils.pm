package QRAttendance::DB::Utils;

use QRAttendance::Policy;

#remove later
use Data::Dumper;

use SQL::Abstract;
extends qw/
  QRAttendance::DB
  QRAttendance::Utils
/;
use  QRAttendance::Logger;

has 'sql_abstract' => (
    is      => 'ro',
    isa     => 'SQL::Abstract',
    default => sub { SQL::Abstract->new(array_datatypes => 1) },
    lazy    => 1,
);

has 'api_logger' => (
    is      => 'ro',
    isa     => 'QRAttendance::Logger',
    default => sub { QRAttendance::Logger->global },
    lazy    => 1,
);

#----------------------------------------------------------------------------------#
# custom module for all Utils                                                      #
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub fetch_row_hashref {
    my ($self, $params) = @_;
    $params->{ds} = 'fetchrow_hashref';
    shift->_fetch_row(@_);
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub fetch_all_arrayref {
    my ($self, $params) = @_;
    $params->{ds} = 'fetchall_arrayref';
    shift->_fetch_row(@_);
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub fetch_all_hashref {
    my ($self, $params) = @_;
    $params->{ds} = 'fetchall_hashref';
    shift->_fetch_row(@_);
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub fetch_all_arrayref_hashref {
    my ($self, $params) = @_;
    $params->{ds} = 'selectall_arrayref';
    shift->_fetch_row(@_);
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
# takes arg as key
sub selectall_hashref {
    my ($self, $params) = @_;
    $params->{ds} = 'selectall_hashref';
    $self->_fetch_row($params);
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub _fetch_row {
    my ($self, $params) = @_;

    my $dbi_con = $self->get_dbi_db_con;

    if (not defined $dbi_con) {
        croak "Unable to connect Database " . __PACKAGE__;
    }
    if (not defined $params) {
        croak "_fetch_row operation need parameter " . __PACKAGE__;
    }

    #default
    $params->{ds} //= 'fetchrow_hashref';
    my ($valid, $keys) = $self->validate($params, [qw/query ds/]);
    my $result;

    # open transaction
    # go to try catch
    # search
    if ($valid) {
        my $query = $params->{query};
        my @bind;
        @bind = @{$params->{binds}} if $params->{binds};
        my $dbh    = $dbi_con->{dbh};
        my $sth    = $dbh->prepare($query);
        my $method = $params->{ds};
        my $conn   = $dbi_con->{conn};
        # set mode to ping
        $conn->mode('ping');
        my $external_txn;

        # not in transaction ?
        if (!$conn->in_txn) {
            $dbh->begin_work;
        }
        else {
            $external_txn = 1;
            warn ">>>>> External DB Transaction Detected <<<<\n";
        }

        try {
            $conn->txn(sub {
                    if ($method eq 'selectall_arrayref') {
                        $result = $dbh->selectall_arrayref($query, {Slice => {}}, @bind);
                    } elsif ($method eq 'selectall_hashref') {
                        if(exists $params->{key} && ref($params->{key}) ne 'ARRAY' ) {
                            $params->{key} = [$params->{key}];
                        }
                        $result= $dbh->selectall_hashref($query, $params->{key} // [], $params->{ds_opt}, @bind);
                    }
                    else {
                        if ($sth->can($method)) {
                            $sth->execute(@bind);
                            if (defined $params->{ds_opt}) {
                                $result = $sth->$method(@{$params->{ds_opt}});
                            }
                            else {
                                $result = $sth->$method;
                            }
                        }
                        else {
                            croak "Method $method not supported by db driver";
                        }
                    }
                $dbh->commit if (!$external_txn);
            });
        } catch {
            $dbh->rollback;
            croak "Error while fetching $query error $_ \n db error ". $dbh->errstr;
            if (eval { $_->isa('DBIx::Connector::RollbackError') }) {
                croak 'Transaction aborted: ', $_->error;
                croak 'Rollback failed too: ', $_->rollback_error;
            } else {
                croak "Caught exception in DB::utils::update method: $_";
            }
        };
    }
    else {
        $self->api_logger->error("Required params missing " . Dumper($keys));
    }

    return $result;
}

#----------------------------------------------------------------------------------#
# Prepare and execute a single statement. Returns the number of rows affected
# if the query was successful, returns undef if an error occurred, and
# returns -1 if the number of rows is unknown or not available.
# Note that this method will return 0E0 instead of 0 for 'no rows were affected',
# in order to always return a true value if no error occurred.
#----------------------------------------------------------------------------------#
sub do {
    my ($self, $params) = @_;

    my $dbi_con = $self->get_dbi_db_con;

    if (not defined $dbi_con) {
        croak "Unable to connect Database " . __PACKAGE__;
    }
    if (not defined $params) {
        croak "do operation need parameter " . __PACKAGE__;
    }

    #default
    my ($valid, $keys) = $self->validate($params, [qw/query/]);
    my $result;

    # open transaction
    # go to try catch
    # do
    if ($valid) {
        my $dbh   = $dbi_con->{dbh};
        my @binds = ();
        if (defined $params->{binds}) {
            @binds = @{$params->{binds}};
        }
        my $conn = $dbi_con->{conn};
       # set mode to ping
        $conn->mode('ping');
        my $external_txn;
        #### TODO 
        # transaction doesnt works well here fix it

        #already in transaction
        if (!$conn->in_txn) {
            $dbh->begin_work;
        }
        else {
            $external_txn = 1;
            warn "\t >>> Do: External DB Transaction Detected  <<< \n";
        }
        try {
            $conn->svp(sub {
                $result = $dbh->do($params->{query}, undef, @binds);
                if ($result eq '0E0') {
                    $self->api_logger->info("Zero rows affected with DO query");

                    #zero rows affected
                    $result = 0;
                }
                $dbh->commit();
                $self->api_logger->info("$result rows affected with query");
            });
        } catch {
            # rollback is innefctive with autocommit
            $dbh->rollback() if (!$external_txn);
            $self->api_logger->error("Do query error occrured rollback");
            my $error = $dbh->errstr;
            if (eval { $_->isa('DBIx::Connector::RollbackError') }) {
                $self->api_logger->error( 'Transaction aborted: ', $_->error);
                $self->api_logger->error('Transaction rollback failed too: ', $_->rollback_error);
            }
            else {
                croak "Error while performing do request $error Caught exception: $_";
            }
        };
    } else {
        $self->api_logger->error("Required params missing " . Dumper($keys));
    }
    return $result;

}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub update {
    my ($self, $params) = @_;

    my $dbi_con = $self->get_dbi_db_con;

    if (not defined $dbi_con) {
        croak "Unable to connect Database " . __PACKAGE__;
    }
    if (not defined $params) {
        croak "update operation need parameter " . __PACKAGE__;
    }

    my ($valid, $keys) = $self->validate($params, [qw/table update_val where_hash/]);
    my $result;
    if ($valid) {

        my $table      = $params->{table};
        my $update_val = $params->{update_val};
        my $where      = $params->{where_hash};
        my $returning  = $params->{returning} // {returning => '"id"'};
        my $abstract   = $self->sql_abstract;
        my ($stmt, @bind) = $abstract->update($table, $update_val, $where, $returning);
        my $dbh = $dbi_con->{dbh};
        my $sth = $dbh->prepare($stmt);
        my $conn = $dbi_con->{conn};
        # set mode to ping
        $conn->mode('ping');

        my $external_txn;
        #already in transaction
        if (!$conn->in_txn) {
            $dbh->begin_work;
        }
        else {
            $external_txn = 1;
            warn "\t >>> Update: External DB Transaction Detected  <<< \n";
        }

        try {
            $conn->txn(sub {
                $result = $sth->execute(@bind);
                if ($result > 0) {
                    $self->api_logger->info("Data updated to $table Rows affected $result");
                }
                else {
                    $self->api_logger->error("Possible Data update ERROR to $table Rows affected $result");
                }
                #when already in transaction dont commit
                $dbh->commit() if (!$external_txn);
            });
        } catch {
            $self->api_logger->error("Table data update error for table $table");
            $dbh->rollback;
            if (eval { $_->isa('DBIx::Connector::RollbackError') }) {
                croak 'Transaction aborted: ', $_->error;
                croak 'Rollback failed too: ', $_->rollback_error;
            } else {
                croak "Caught exception in DB::utils::update method: $_";
            }
        };
    } else {
        $self->api_logger->error("Required params missing " . Dumper($keys));
    }

    return $result;
}

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut