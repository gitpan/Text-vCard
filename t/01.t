#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More tests => 2;
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }

my $cards = Text::vCard->load('t/data1.vcf');

foreach my $vcard (@{$cards}) {
	isa_ok($vcard,'Text::vCard');

	my $addresses = $vcard->addresses();
	
	foreach my $address (@{$addresses}) {
#		print "ADR:\n";
#		print Dumper($address);
		print "B: " . join(' : ' , $address->types()) . "\n";

		if($address->is_type('work')) {
			print "Is work\n";
		}
		$address->remove_type('intl');
		print join(' : ' , $address->types()) . "\n";
		
	}
	
#	print Dumper(\@addresses);

}

	print Dumper($cards);

