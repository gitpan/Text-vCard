#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 2;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }


 my $reader = Text::vFile->new( source_file => "t/evolution.vcf" );
    while ( my $object = $reader->next ) {
        print $object->fn();
        print Dumper($object);
isa_ok($object,'Text::vCard');
    }


print Dumper($reader);


