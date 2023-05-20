package QRAttendance::Utils;

use QRAttendance::Policy;

use Moose::Util;
use JSON::XS;

#----------------------------------------------------------------------------------#
# custom module                                       #
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
# validate data keys needed
#----------------------------------------------------------------------------------#
sub validate {
    my ($self, $data, $keys) = @_;

    my $valid = 1;
    my $missing;
    foreach (@{$keys}) {
        if (defined $data->{$_} && ref($data->{$_}) eq 'ARRAY') {
            if (scalar @{$data->{$_}} < 1) {
                push(@$missing, $_);
                $valid = 0;
            }
        }
        if (not defined $data->{$_}) {
            push(@$missing, $_);
            $valid = 0;
        }
        if (defined $data->{$_} && $data->{$_} =~ /^\s*$/) {
            push(@$missing, $_);
            $valid = 0;
        }
    }
    my $missing_str = join ', ', map qq/'$_'/, @$missing;

    return wantarray ? ($valid, $missing, $missing_str) : $valid;
}

#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub enc_json {
    my ($self, $data) = @_;

    return JSON::XS->new->utf8->encode($data);
}
#----------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------#
sub dcd_json {
    my ($self, $data) = @_;

    return JSON::XS->new->utf8->allow_nonref->decode($data);
}

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut