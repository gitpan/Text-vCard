#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 7;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }


my $reader = Text::vFile->new( source_file => "t/phone_v1.vcf" );
my $vcard = $reader->next;
isa_ok($vcard,'Text::vCard');
is($vcard->fn(),'Blogs, Joe','Full name match');

my $tels = $vcard->tels();
is($tels->[0]->value(),'4534345645','phone number 1 ok');
# This will not work yet - because it is 2.1 version not 3 - get jay to fix
#ok($tels->[0]->is_type('home'),'phone number is home type');

is($tels->[1]->value(),'2563456456','phone number 2 ok');
#ok($tels->[1]->is_type('cell'),'phone number is home type');

is($vcard->url(),'http://www.domain.com/','Url ok');

my $emails = $vcard->emails();
is($emails->[0]->value(),'joe@domain.com','Email matched ok');

