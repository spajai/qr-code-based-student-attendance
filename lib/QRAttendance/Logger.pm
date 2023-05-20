# Implemented optimizations:
# * log-method's (error(), warn(), etc.) implementation generated
#   individually for each log-object (depending on it configuration)
#   to include only minimum necessary code to do it work
#   - each time log-object configuration changes (by calling config())
#     log-method's implementation re-generated to comply new configuration
#   - different log-objects may have different configuration and so will
#     need different implementation for same log-methods - so we have to
#     use unique package/class for each log-object (with class names looks
#     like 'Log::Fast::_12345678') - these classes will implement only
#     log-methods and inherit everything else from parent class (Log::Fast)
# * implementation for log-methods inactive on current log level replaced
#   by empty 'sub{}'
#   - each time log level changes (by calling config() or level())
#     implementation of all log-methods updated according to current
#     log level and set either to real implementation or empty 'sub{}'
# * if prefixes %D and/or %T are used, then cache will be used to store
#   formatted date/time to avoid calculating it often than once per second
# * when logging to syslog, packet header (which may contain:
#   log level, facility, timestamp, hostname, ident and pid) will be cached
#   (one cached header per each log level)
#   - if {add_timestamp} is true, then cached header will be used only for
#     one second and then recalculated
#   - if user change {ident} (by calling config() or ident()) cached
#     headers will be recalculated
# * if log-methods will be called with single param sprintf() won't be used
 
package QRAttendance::Logger;
use 5.010001;
use warnings;
use strict;
use utf8;
use Carp;
#autoflush 1
BEGIN{ $| = 1; };

our $VERSION = 'v2.0.1';
 
use Scalar::Util qw( refaddr );
use Socket;
use Sys::Hostname ();
use Time::HiRes ();
# from RFC3164
use constant log_user       => 1*8;
use constant log_error      => 3;
use constant log_warning    => 4;
use constant log_notice     => 5;
use constant log_info       => 6;
use constant log_debug      => 7;
use constant PRI  => {
    error   => 3,
    warn    => 4,
    notice  => 5,
    info    => 6,
    debug   => 7,
};
use constant DEFAULTS => {
    level           => 'debug',
    prefix          => q{},
    type            => 'fh',
    # used only when {type}='fh':
    fh              => \*STDERR,
    # used only when {type}='unix':
    path            =>  '/dev/log', ## no critic(ProtectPrivateSubs)
    facility        => 1*8,
    add_timestamp   => 1,
    add_hostname    => 0,
    hostname        => Sys::Hostname::hostname(),
    ident           => do { my $s = $0; utf8::decode($s); $s =~ s{\A.*/(?=.)}{}xms; $s },
    add_pid         => 1,
    pid             => $$,
};

my $GLOBAL;
 
sub new {
    my ($class, $opt) = @_;
    $opt ||= {};
    croak 'options must be HASHREF' if ref $opt ne 'HASH';
 
    my $self = { # will also contain all keys defined in DEFAULTS constant
        _sock           => undef,   # socket to {path}
        _header_err     => q{},     # cached "<PRI>TIMESTAMP IDENT[PID]: "
        _header_warn    => q{},     # --"--
        _header_notice  => q{},     # --"--
        _header_info    => q{},     # --"--
        _header_debug   => q{},     # --"--
        _header_time    => 0,       # last update time for {_header_*}
        # used only if {prefix} contain %D or %T:
        _date           => q{},     # cached "YYYY-MM-DD"
        _time           => q{},     # cached "HH:MM:SS"
        _dt_time        => 0,       # last update time for {_date} and {_time}
    };
 
    my $sub_class = $class . '::_' . refaddr($self);
    { no strict 'refs';
      @{$sub_class.'::ISA'} = ( $class );
    }
    bless $self, $sub_class;
 
    my $api_config = {
        prefix => "[%L] [%D %T] [$$] [%P::%F() %N]:",
        type   => 'fh',
        fh     => $ENV{QRATTENDANCE_API_LOG_PATH} ? $ENV{QRATTENDANCE_API_LOG_PATH}.'/api.log' : \*STDERR,
    };
    #get from config directly or opt
    $self->config({ %{ DEFAULTS() }, %{ $api_config }, %{ $opt } });  ## no critic (ProhibitCommaSeparatedStatements)
 
    return $self;
}
 
sub global {
    my $class = shift;
    $GLOBAL ||= $class->new();
    return $GLOBAL;
}

sub config {
    my ($self, $opt) = @_;
    croak 'options must be HASHREF' if ref $opt ne 'HASH';
 
    for my $key (keys %{ $opt }) {
        if (!exists DEFAULTS->{ $key }) {
            croak 'unknown option: '.$key;
        }
        $self->{ $key } = $opt->{ $key };
    }
 
    $self->_generate_methods();
    if ($self->{type} eq 'unix') {
        $self->_connect_unix();
        $self->ident($self->{ident});
    }
    $self->level($self->{level});
 
    return;
}
 
sub level {
    my ($self, $level) = @_;
    my $prev_level = $self->{level};
    if (defined $level) {
        if (!exists PRI->{$level}) {
            croak '{level} must be one of: '.join ', ', keys %{ PRI() };
        }
        $self->{level} = $level;
        $self->_setup_level();
    }
    return $prev_level;
}
 
sub ident {
    my ($self, $ident) = @_;
    my $prev_ident = $self->{ident};
    if (defined $ident) {
        $self->{ident} = $ident;
        $self->_update_header();
    }
    return $prev_ident;
}
 
### Internal
 
sub _connect_unix {
    my ($self) = @_;
    socket $self->{_sock}, AF_UNIX, SOCK_DGRAM, 0 or croak "socket: $!";
    connect $self->{_sock}, sockaddr_un($self->{path}) or croak "connect: $!";
    return;
}
 
sub _update_header {
    my ($self) = @_;
    my $h = q{};
    if ($self->{add_timestamp}) {
        $self->{_header_time} = time;
        $h .= substr localtime $self->{_header_time}, 4, 16; ## no critic(ProhibitMagicNumbers)
    }
    if ($self->{add_hostname}) {
        $h .= $self->{hostname} . q{ };
    }
    my $ident_utf8 = $self->{ident};
    utf8::encode($ident_utf8);
    $h .= $ident_utf8;
    if ($self->{add_pid}) {
        $h .= '[' . $self->{pid} . ']';
    }
    $h .= ': ';
    for my $level (keys %{ PRI() }) {
        $self->{'_header_'.$level}
            = '<' . ($self->{facility} + PRI->{$level}) . '>' . $h;
    }
    return;
}
 
sub _setup_level {
    my ($self) = @_;
    my $pkg = ref $self;
    for my $level (keys %{ PRI() }) {
        my $is_active = PRI->{$level} <= PRI->{$self->{level}};
        no strict 'refs';
        no warnings 'redefine';
        *{$pkg.q{::}.$level} = $is_active ? \&{$pkg.q{::_}.$level} : sub {};
    }
    return;
}
 
sub _generate_methods {    ## no critic(ProhibitExcessComplexity)
    my ($self) = @_;
    my $pkg = ref $self;
 
    my %feature = map {$_=>1} $self->{prefix} =~ /%(.)/xmsg;
    $feature{timestamp} = $self->{type} eq 'unix' && $self->{add_timestamp};
 
    my @pfx = split /(%.)/xms, $self->{prefix};
    for (0 .. $#pfx) {
        utf8::encode($pfx[$_]);
    }
 
    for my $level (keys %{ PRI() }) {
        # ... begin
        my $code = <<'EOCODE';
sub {
    my $self = shift;
    my $msg = @_==1 ? $_[0] : sprintf shift, map {ref eq 'CODE' ? $_->() : $_} @_;
    utf8::encode($msg);
EOCODE
        # ... if needed, get current time
        if ($feature{S}) {
            $code .= <<'EOCODE';
    my $msec = sprintf '%.05f', Time::HiRes::time();
    my $time = int $msec;
EOCODE
        }
        elsif ($feature{D} || $feature{T} || $feature{timestamp}) {
            $code .= <<'EOCODE';
    my $time = time;
EOCODE
        }
        # ... if needed, update caches
        if ($feature{D} || $feature{T}) {
            $code .= <<'EOCODE';
    if ($self->{_dt_time} != $time) {
        $self->{_dt_time} = $time;
        my ($sec,$min,$hour,$mday,$mon,$year) = localtime $time;
        $self->{_date} = sprintf '%04d-%02d-%02d', $year+1900, $mon+1, $mday;
        $self->{_time} = sprintf '%02d:%02d:%02d', $hour, $min, $sec;
    }
EOCODE
        }
        if ($feature{timestamp}) {
            $code .= <<'EOCODE';
    if ($self->{_header_time} != $time) {
        $self->_update_header();
    }
EOCODE
        }
        # ... calculate prefix
        $code .= <<'EOCODE';
    my $prefix = q{}
EOCODE
        for my $pfx (@pfx) {
            if ($pfx eq q{%L}) { ## no critic(ProhibitCascadingIfElse)
                $code .= <<"EOCODE"
      . "\Q$level\E"
EOCODE
            }
            elsif ($pfx eq q{%S}) {
                $code .= <<'EOCODE'
      . $msec
EOCODE
            }
            elsif ($pfx eq q{%D}) {
                $code .= <<'EOCODE'
      . $self->{_date}
EOCODE
            }
            elsif ($pfx eq q{%T}) {
                $code .= <<'EOCODE'
      . $self->{_time}
EOCODE
            }
            elsif ($pfx eq q{%P}) {
                $code .= <<'EOCODE'
      . caller(0)
EOCODE
            }
            elsif ($pfx eq q{%F}) {
                $code .= <<'EOCODE'
      . do { my $s = (caller(1))[3] || q{}; substr $s, 1+rindex $s, ':' }
EOCODE
            }
            elsif ($pfx eq q{%_}) {
                $code .= <<'EOCODE'
      . do { my $n=0; 1 while caller(2 + $n++); ' ' x $n }
EOCODE
            }
            elsif ($pfx eq q{%%}) {
                $code .= <<'EOCODE'
      . '%'
EOCODE
            }
            elsif ($pfx eq q{%N}) {
                $code .= <<'EOCODE'
      . (caller(0))[2]
EOCODE
            }
            else {
                $code .= <<"EOCODE"
      . "\Q$pfx\E"
EOCODE
            }
        }
        $code .= <<'EOCODE';
    ;
EOCODE
        # ... output
        if ($self->{type} eq 'fh') {
            $code .= <<'EOCODE';
    print { $self->{fh} } $prefix, $msg, "\n" or die "print() to log: $!";
EOCODE
        }
        elsif ($self->{type} eq 'unix') {
            $code .= <<"EOCODE";
    my \$header = \$self->{_header_$level};
EOCODE
            $code .= <<'EOCODE';
    send $self->{_sock}, $header.$prefix.$msg, 0 or do {
        $self->_connect_unix();
        send $self->{_sock}, $header.$prefix.$msg, 0 or die "send() to syslog: $!";
    };
EOCODE
        }
        else {
            croak '{type} should be "fh" or "unix"';
        }
        # ... end
        $code .= <<'EOCODE';
}
EOCODE
        # install generated method
        no strict 'refs';
        no warnings 'redefine';
        *{$pkg.'::_'.$level} = eval $code;  ## no critic (ProhibitStringyEval)
    }
 
    return;
}

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut