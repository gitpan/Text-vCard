#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More qw(no_plan);
# Check we can load module
BEGIN { use_ok( 'Text::vCard::Addressbook' ); }

my @card_types = qw(evolution.vcf apple_2.1_unicode.vcf);

foreach my $card_type (@card_types) {
	ok($card_type,"Running from $card_type");
	my $adbk = Text::vCard::Addressbook->new({ source_file => "t/$card_type" });
	isa_ok($adbk,'Text::vCard::Addressbook');
	my $vcards = $adbk->vcards();
	
	is(scalar(@{$vcards}),1,"$card_type has 1 vcards as expected");
	my $vcard = $vcards->[0];
	is($vcard->get('fn')->[0]->value(),'T-firstname T-surname',"$card_type has fn data correct");

	my $t = $vcard->get({
		'element_type' => 'tel',
		'types' => 'home',
	});
	is($t->[0]->value(),'020 666 6666','got expected phone number');
}
