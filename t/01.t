#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 32;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }

my $cards = Text::vCard->load('t/simple.vcf');

my $vcard = $cards->[0];
isa_ok($vcard,'Text::vCard');

is($vcard->fn(),'T-firstname T-surname','Full name matches');

my $new_name = 'New Test Full Name';
is($vcard->fn($new_name),$new_name,'Setting new full name');
is($vcard->fn(),$new_name,'New full name matches');

is($vcard->addresses('work'),undef,"No work addresses as expected");
my @home_addr = $vcard->addresses('home');
is(scalar(@home_addr),2,"One address of type home in an array");

ok($home_addr[0]->is_type('pref'),'Returned the prefered address first');

my $addresses = $vcard->addresses();

is(ref($addresses),'ARRAY','Returned array ref as wanted');

my $address = $addresses->[0];

my %address_test1 = (
	'po_box' => '',
	'extended' => '',
	'street' => 'Test Road',
	'city' => 'Test City',
	'region' => '',
	'post_code' => 'Test Postcode',
	'country' => 'Test Country',
);

while( my($field,$value) = each %address_test1 ) {
	is($address->$field(),$value,"ADR: $field matches");
}

my %address_test2 = (
	'po_box' => 'PO BOX',
	'extended' => '',
	'street' => '12 Test Road',
	'city' => 'Another Test City',
	'region' => '',
	'post_code' => 'Test Postcode',
	'country' => 'Test Country',
);

while( my($field,$value) = each %address_test2 ) {
	is($address->$field($value),$value,"ADR: $field update ok matches");
}

is($address->update_value(),'PO BOX;;12 Test Road;Another Test City;;Test Postcode;Test Country','ADR: value updated ok');
	
my $name = $vcard->name();

my %name_test = (
	'family' => 'T-surname',
	'given' => 'T-firstname',
	'additional' => '',
	'prefixes' => '',
	'suffixes' => '',
);

while( my($field,$value) = each %name_test ) {
	is($name->$field(),$value,"N: $field matches");
}

my $tels = $vcard->tels();
my $tel1 = $tels->[0];
is($tel1->value(),'020 666 6666','TEL: Home phone number ok');
ok($tel1->is_type('home'),'TEL: Home type match');
ok(!$tel1->is_type('work'),'TEL: Not work type as expected');


#print Dumper($vcard);

