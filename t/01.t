#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 22;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }

my $cards = Text::vCard->load('t/simple.vcf');

my $vcard = $cards->[0];
isa_ok($vcard,'Text::vCard');


my $addresses = $vcard->addresses();

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
	
my $name = $vcard->n();

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


#		print "Street: " . $address->street() . "\n";
#		print "ADR:\n";
#		print Dumper($address);
#		print "B: " . join(' : ' , $address->types()) . "\n";

#		if($address->is_type('work')) {
#			print "Is work\n";
#		}
#		$address->remove_type('intl');
#		print join(' : ' , $address->types()) . "\n";
		
#	}
	
#	print Dumper(\@addresses);

	#print Dumper($cards);

