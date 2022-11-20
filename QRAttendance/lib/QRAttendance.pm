package QRAttendance;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
extends 'QRAttendance::API';

use QRAttendance::DB;
use QRAttendance::Utils;
use QRAttendance::Logger;
# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Session
    Authentication
    Session Session::Store::DBI
    Session::State::Cookie
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in qrattendance.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'QRAttendance',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    encoding => 'UTF-8', # Setup request decoding and response encoding
    'always_catch_http_exceptions' => 1,
    'default_view'                 => 'Web',
    'View::JSON'                   => {
        'expose_stash' => [qw/data/],    # defaults to everything
    },
    'Plugin::Static::Simple' => {
        'include_path' => [__PACKAGE__->path_to('root'), '/tmp'],
    },

    'Plugin::Session' =>  {
        expires   => 3600,
        dbi_dsn   => 'dbi:Pg:dbname=qrattendance;host=localhost;port=5432',
        dbi_user  => 'sushrut',
        dbi_pass  => 'sushrut',
        dbi_table => 'sessions',
        dbi_id_field => 'sess_id',
        dbi_data_field => 'session_data',
        dbi_expires_field => 'expires',
    },



#  my $dbh = DBI->connect(
#             $cfg->{'dbi_dsn'},
#             $cfg->{'dbi_user'},
#             $cfg->{'dbi_pass'},
#             \%options,
#         ) or Catalyst::Exception->throw( message => $DBI::errstr );




    'Plugin::Authentication' => {
        default => {
            credential => {
                class => '+QRAttendance::Authentication::Credential::Password',
            },
            store => {
                class => '+QRAttendance::Authentication::Store::DBI',
            },
        },
    },
);


#add our custom logger much faster
__PACKAGE__->log( QRAttendance::Logger->global());

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

QRAttendance - Catalyst based application

=head1 SYNOPSIS

    script/qrattendance_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<QRAttendance::Controller::Root>, L<Catalyst>

=head1 AUTHOR

,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
