#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More qw(no_plan);
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard' ); }
BEGIN { use_ok( 'Text::vCard::Addressbook' ); }

local $SIG{__WARN__} = sub { die $_[0] };

#######
# Test new()
#######

my $function = Text::vCard::new('foo::bar',{ 'source_file' => 't/simple.vcf'});
is(ref($function),'foo::bar','Can use as a base class');

my $hash = Text::vCard::new({foo => 'bar'},{ 'source_file' => 't/simple.vcf'});
is(ref($hash),'HASH','new() retruns HASH when supplied hash');

eval {
	Text::vCard::new(undef);
};
like($@, qr/Use of uninitialized value in bless/,'Errors if no class supplied');
$@ = 'foo';

my $adbk = Text::vCard::Addressbook->new({ 'source_file' => 't/simple.vcf'});
my $vcard = $adbk->vcards()->[0];

#######
# Test add_node()
#######
eval {
	$vcard->add_node();
};
like($@,qr/Must supply a node_type/,'Croak if add_node() not supplied with anything');

eval {
	$vcard->add_node({});
};
like($@,qr/Must supply a node_type/,'Croak if add_node() not supplied with node_type');

my %data = (
	'param' => {
		'HOME,PREF' => undef,
	},
	'value' => ';;First work address - street;Work city;London;Work PostCode;CountryName',
);
my @d = (\%data);

my $new_address = $vcard->add_node({
	'node_type' => 'ADR',
	'data'	=> \@d,
});
isa_ok($new_address,'Text::vCard::Node');

#######
# Test get_of_type()
#######

my $home_adds_pref = $vcard->get_of_type('addresses',[ 'home','pref' ]);

is(scalar(@{$home_adds_pref}),2,'get_of_type() types returns 2 not 3 addresses with array ref');

is($vcard->get_of_type('foo'),undef,'nothing of this type found, undef returned');

my $home_adds = $vcard->get_of_type('addresses','home');

is(scalar(@{$home_adds}),3,'get_of_type() types returns 3 not 3 addresses with scalar');

is($vcard->get_of_type('addresses','foo'),undef,'Undef returned when no addresses available');

is(ref($home_adds),'ARRAY','Returns array ref when called in context');

my @list = $vcard->get_of_type('addresses','pref');
is(scalar(@list),2,'Got all 2 addresses from array');

my @list_all = $vcard->get_of_type('addresses');
is(scalar(@list_all),3,'Got 3 addresses from array as expected');



#######
# Test get()
#######

eval {
	$vcard->get();
};
like($@,qr/You did not supply an element type/,'get() croaks is no params supplied');

my $addresses = $vcard->get({ 'element_type' => 'addresses' });
my $also_addresses = $vcard->get('addresses');

ok(eq_array($addresses,$also_addresses),'get() with single element and element_type match');

my $home_adds_get = $vcard->get({ 
	'element_type' => 'addresses',
	'types' => [ 'home','pref' ],
});

is(scalar(@{$home_adds_get}),2,'get() types returns 2 not 3 addresses');




#my $addresses2 = $vcard->get({ 'element_type' => 'addresses', 'types' => 'pref' });

#  foreach my $address (@{$addresses2}) {
#	print Dumper($address);
#	print "Prefered\n" if $address->is_type('pref');
#	print $address->street() . "\n";
#  }


#foreach my $address (@{$home_adds}) {
#	print Dumper($address->{params});
#	print "Check $type is ok\n" if $address->is_type($type);
#	print "Check $type is NOT ok\n" unless $address->is_type($type);

#}


#my $new_address = $vcards->[0]->add_node()


  # Setting values on an address element
#  $addresses->[0]->street('The burrows');
#  $addresses->[0]->region('Wimbeldon common');

  # Checking an address is a specific type
#  $addresses->[0]->is_type('fax');
#  $addresses->[0]->add_types('home');
#  $addresses->[0]->remove_types('work');


