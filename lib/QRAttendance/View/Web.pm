package QRAttendance::View::Web;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    INCLUDE_PATH => [
        QRAttendance->path_to('root', 'site'), QRAttendance->path_to('root', 'lib'),
        QRAttendance->path_to('root'), QRAttendance->path_to('templates'),
    ],
    TEMPLATE_EXTENSION => '.tt',
    CATALYST_VAR       => 'c',
    TIMER              => 0,
    ENCODING           => 'utf-8',
    render_die         => 1,
    # PRE_PROCESS        => 'site_config.tt',
    # WRAPPER            => 'wrapper.tt',
);

=head1 NAME

QRAttendance::View::Web - TT View for QRAttendance

=head1 DESCRIPTION

TT View for QRAttendance.

=head1 SEE ALSO

L<QRAttendance>

=head1 AUTHOR

,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
