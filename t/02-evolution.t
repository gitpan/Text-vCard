#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 5;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }


my $reader = Text::vFile->new( source_file => "t/evolution.vcf" );
my $vcard = $reader->next;
isa_ok($vcard,'Text::vCard');
is($vcard->fn(),'Sister','Full name match');

my $tels = $vcard->tels();
is($tels->[0]->value(),'345234534 234','phone number ok');


my $uid = $vcard->uid();
is($uid->value(),'pas-id-3EDER42342390','uid ok');


# This will not work yet - because it is 2.1 version not 3 - get jay to fix
#ok($tels->[0]->is_type('home'),'phone number is home type');