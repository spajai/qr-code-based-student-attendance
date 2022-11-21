package Moose::Exception::MustSupplyAnAttributeToConstructWith;
our $VERSION = '2.2201';

use Moose;
extends 'Moose::Exception';
with 'Moose::Exception::Role::ParamsHash';

has 'class' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

sub _build_message {
    "You must supply an attribute to construct with";
}

__PACKAGE__->meta->make_immutable;
1;
