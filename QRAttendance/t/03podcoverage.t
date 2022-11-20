#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;

plan skip_all => 'set TEST_POD to enable this test' unless $ENV{TEST_POD};

eval "use Test::Pod::Coverage 1.04";
plan skip_all => 'Test::Pod::Coverage 1.04 required' if $@;

eval "use Pod::Coverage 0.20";
plan skip_all => 'Pod::Coverage 0.20 required' if $@;

all_pod_coverage_ok();
