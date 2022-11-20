{

    redis => {
        ## Try each 100ms up to 2 seconds (every is in microseconds)
        reconnect => $ENV{REDIS_RECONNECT}   // 5,
        every     => $ENV{REDIS_EVERY}       // 200_000,
        server    => $ENV{REDIS_SERVER_HOST} // '127.0.0.1:6379',
        password  => $ENV{REDIS_PASSWORD}    // undef,
        redis_db  => $ENV{REDIS_DB_SELECT}   // undef,              #to select db
        encoding => undef,    #more performance
        name     => 'asi',    #audiocast session id
                              # expires           => 3600, #use from application connection conf should not over write
                              # reconnect         => 1,
    },

    auth_engine => {
        'auth_security' => 'argon2'
    },

    db => {
        dbi => {
            port           => $ENV{PGPORT} // 5432,
            dbname         => $ENV{PGDATABASE},
            host           => $ENV{PGHOST} // 'localhost',
            username       => $ENV{PGUSER},
            password       => $ENV{PGPASSWORD},
            service        => $ENV{PGSERVICE},
            pgservice_file => $ENV{PGSERVICEFILE}
        },
    },

}
