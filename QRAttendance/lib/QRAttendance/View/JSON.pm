package QRAttendance::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

use JSON::XS;

=head1 NAME

QRAttendance::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<QRAttendance>

=head1 DESCRIPTION

Catalyst JSON View.

=cut

sub encode_json ($) {
    my ($self, $c, $data) = @_;

    #canonical  will sort
    my $coder = JSON::XS->new->pretty->allow_nonref->utf8;
    $coder->encode($data->{data});#$c->stash->{data}
}

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut

1;
