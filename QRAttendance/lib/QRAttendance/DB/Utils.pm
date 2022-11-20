package QRAttendance::DB::Utils;

use QRAttendance::Policy;

#remove later
use Data::Dumper;

extends qw/
  QRAttendance::DB
  QRAttendance::Utils
/;

#----------------------------------------------------------------------------------#
# custom module for all Utils                                                      #
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub insert {
    my ($self, $params) = @_;

    my $dbi_con = $self->dbi_con;

    if (not defined $dbi_con) {
        croak "Unable to connect Database " . __PACKAGE__;
    }
    if (not defined $params) {
        croak "insert operation need parameter " . __PACKAGE__;
    }

    my $valid = $self->validate($params, [qw/table data/]);
    my $result;

    # open transaction
    # go to try catch
    # insert
    # redis-insert if given
    # commit return ID
    # above operation failed ?
    # rollback

    if ($valid) {

        my $table     = $params->{table};
        my $data      = $params->{data};
        my $returning = $params->{returning} // {returning => '"id"'};
        my $abstract  = $self->sql_abstract;
        my ($stmt, @bind) = $abstract->insert($table, $data, $returning);
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
            warn ">>>>>Insert: External DB Transaction Detected <<<<\n";
        }

        try {
            $conn->txn(sub {
                $sth->execute(@bind);
                if (defined $params->{cache_data}) {
                    my $cache      = $params->{cache_data};
                    my $redis_conn = $self->redis_conn;
                    my $command    = $cache->{command};
                    my $values     = $cache->{values};
                    $redis_conn->$command(@{$values});
                    $self->api_logger->info("Data caching enabled & data cached to redis");
                }
                $dbh->commit if (!$external_txn);
                $self->api_logger->info("Data inserted to $table");
                $result = $sth->fetch()->[0];
            });
        } catch {
            $self->api_logger->error("Data inserted error for table $table");
            $dbh->rollback;
            if (eval { $_->isa('DBIx::Connector::RollbackError') }) {
                croak 'Transaction aborted: ', $_->error;
                croak 'Rollback failed too: ', $_->rollback_error;
            } else {
                croak "Caught exception in DB::utils::update method: $_";
            }
        };

    }

    return $result;
}

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

sub get_entity_value_map {
    my ($self, $params) = @_;

    my $table         = $params->{table};
    my $columns       = $params->{columns};
    my $reverse_hash  = $params->{reverse_hash};
    my $where         = $params->{where};
    my $col_str       = join(',',@$columns);
    my $abstract      = $self->sql_abstract;
    my ($sql, @bind)  = $abstract->select($table, $columns, $where);

    $sql = "select jsonb_object_agg($col_str) as result from ($sql) as sq";

    my $result_json = $self->fetch_row_hashref({ query => $sql, binds => [@bind] });
    #  {"READY": 2, "ACTIVE": 3, "ENDING": 5, "PURGED": 8, "SHELVED": 6, "ARCHIVED": 7, "COMPLETE": 4, "SCHEDULED": 1}

    my $result = $self->dcd_json( $result_json->{result} ) if (defined $result_json->{result});

    if($reverse_hash){
        my %inverse;
        push @{ $inverse{ $result->{$_} } }, $_ for keys %$result;
        return {
            result       => $result,
            reverse_hash => \%inverse
        };
    }

    return $result;

}

sub get_dropdown_entity_value_map {
    my ($self, $params) = @_;

    my $table         = $params->{table};
    my $columns       = $params->{columns} // 'id as id, name as text';
    my $where         = $params->{where};
    my $json_output   = $params->{json_output} // 0;
    my $abstract      = $self->sql_abstract;
    my ($sql, @bind)  = $abstract->select($table, $columns, $where);

    $sql = "select json_agg(row_to_json(sq)) as result from ($sql) as sq;";
    my $result_json = $self->fetch_row_hashref({ query => $sql, binds => [@bind] });

    my $result = $json_output ?  $result_json->{result} : $self->dcd_json( $result_json->{result} );

    return $result;

}

sub get_next_id {
    #note this will increament the values
    my ($self, $talename) = @_;

    my $max_id_data = $self->fetch_row_hashref({
        query => "SELECT nextval(pg_get_serial_sequence(?, 'id')) AS id",
        binds => [$talename]
    });
    return $max_id_data->{id};
}

sub get_current_id {
    my ($self, $seq_name) = @_;

    # event_call_list_contact_id_seq
    my $curr_id_data = $self->fetch_row_hashref({
        query => "SELECT last_value AS id FROM $seq_name",
    });

    return $curr_id_data->{id};
}

1;
