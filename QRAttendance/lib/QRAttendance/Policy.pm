package QRAttendance::Policy;

# ABSTRACT: enable all of the features of Modern Perl at QRAttendance with one command

=head1 NAME
QRAttendance::policy
=head1 SYNOPSIS
  package Whatever;
  use QRAttendance::policy;


=head1 DESCRIPTION
This module will do the same as:
  use strict;
  use warnings FATAL => 'all';
  no warnings 'experimental::smartmatch';
  use utf8;
  use Try::Tiny;
  use Carp;
  use namespace::autoclean;
  use true;

=cut

use strict;
use warnings;
use utf8 ();
use true ();
use Carp ();
use Try::Tiny ();
use namespace::autoclean ();
use Hook::AfterRuntime;
use Import::Into;
use Moose ();
use Moose::Util ();


sub import {
    my ($class, @opts) = @_;
    my $caller = caller;

    my %opt = map { $_ => 1 } @opts;

    strict->import::into($caller);
    utf8->import::into($caller);
    true->import();
    Carp->import::into($caller);
    Try::Tiny->import::into($caller);

    # This must come after anything else that might change warning
    # levels in the caller (e.g. Moose)
    warnings->import();


    if($opt{role}) {
      require Moose::Role;
      Moose::Role->import({into=>$caller});
    } else {
      Moose->import({into=>$caller});

      after_runtime { # Hook::AfterRuntime
          $caller->meta->make_immutable();
      };
    }

    namespace::autoclean->import(
        -cleanee => $caller,
    );

    return;
}

1;

=head1 AUTHOR

spajai@cpan.org

=head1 LICENSE

=cut