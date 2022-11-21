#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;

plan skip_all => 'set TEST_POD to enable this test' unless $ENV{TEST_POD};
eval "use Test::Pod 1.14";
plan skip_all => 'Test::Pod 1.14 required' if $@;

all_pod_files_ok();

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut