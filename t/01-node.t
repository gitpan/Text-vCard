#!/usr/bin/perl -w

use strict;

use lib qw( ./blib/lib ../blib/lib );

use Test::More qw(no_plan);
use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard::Node' ); }

local $SIG{__WARN__} = sub { die $_[0] };

#####
# Set up some test data
#####

# ok data
my %data = (
	'param' => {
		'HOME,PREF' => undef,
	},
	'value' => ';;First work address - street;Work city;London;Work PostCode;CountryName',
);

# Address fields
my $fields = ['po_box','extended','street','city','region','post_code','country'];

#####
# Test new()
#####

my $foo = Text::vCard::Node::new('foo::bar', { fields => ['value'] });

is(ref($foo),'foo::bar','Can use as a base class');

my $hash = Text::vCard::Node::new({foo => 'bar'},{ 'fields' => ['value'] });
is(ref($hash),'HASH','new() retruns HASH when supplied hash');

eval {
	Text::vCard::Node::new(undef, { 'fields' => ['value'] });
};
like($@, qr/Use of uninitialized value in bless/,'Errors if no class supplied');
$@ = 'foo';

eval {
	Text::vCard::Node->new({});
};
like($@,qr/No fields defined/,'new() carps when no fields supplied');

eval {
	Text::vCard::Node->new({ 'fields' => { 'duff' => 'hash' } });
};
like($@,qr/fields is not an array ref/,'new() carps when fields is not an array ref');

my %too_few_value_data = (
	'value' => 'Street;Work city;London;Work PostCode;CountryName',
);
eval {
	my $duff =  Text::vCard::Node->new({
		fields => $fields,
		data => \%too_few_value_data,
	});
};
like($@,qr/Data value had 5 elements expecting 7/,'new() carp on wrong number of elements in value comp to fields');

# Working nodes

# Create without a node_type - should be fine
my $no =  Text::vCard::Node->new({
	fields => $fields,
	data => \%data,
});

# Create without a data - should be fine
my $no_data =  Text::vCard::Node->new({
	fields => $fields,
});
is($no_data->street(),undef,'Created node with no data and methods created');

# Create 'working' node
my $node = Text::vCard::Node->new({
	node_type => 'address', # Auto upper cased
	fields => $fields,
	data => \%data,
});

is($no->street(),$node->street(),'new() without node_type still works ok');



#####
# types()
#####
my $types = $node->types();
my @types = $node->types();
ok(scalar(@types),'types() returns stuff');
ok(eq_array($types,\@types),'types() ok in array or scalar context');
is($no_data->types(),undef,'types() get undef when there are none');

#####
# is_type()
#####
ok($node->is_type('home'),'is_type() home type matches');
ok(!$node->is_type('work'),'is_type() not work address type');
is($no_data->is_type('work'),undef,'is_type() undef when no params');

#####
# is_pref()
#####
ok($node->is_pref(),'is_pref() this is a prefered address');
$node->remove_types('pref');
is($node->is_pref(),undef,'is_pref() get undef when not pref');
is($no_data->is_pref(),undef,'is_pref() get undef if no params');

#####
# remove_types()
#####
is($no_data->remove_types('wibble'),undef,'remove_types() when no params - no error');
is($node->remove_types('wibble'),undef,'remove_types() undef when scalar, node has params and no match');
is($node->remove_types(['home']),1,'remove_types() get a true value in array context when sucess');

#####
# add_types()
#####
# Test the types
$node->add_types('WoRk');
ok($node->is_type('wOrk'),'is_type() Added work type and check non-cases sensative');
$node->remove_types(['Work','Home']);
ok(!$node->is_type('Work'),'is_type() Removed work type and check non-cases sensative');
ok(!$node->is_type('home'),'is_type() Removed several types');
$node->add_types(['work','home']);
ok($node->is_type('work') && $node->is_type('home'),'is_type() Added two types ok');
$no_data->add_types('work');
ok($no_data->is_type('work'),'is_type() Added type to node with no params');

#####
# AUTOLOAD
#####

is($node->po_box(),'','AUTOLOAD - Po box empty as expected');
is($node->street(),'First work address - street','AUTOLOAD - Street address matches');
is($node->country('Moose vill'),'Moose vill','AUTOLOAD - set ok');

eval {
	$node->duff_method();
};
like($@,qr/duff_method method which is not valid for this node/,'AUTOLOAD - carp when method not valid');

####
# export_data()
####
my $export = ';;First work address - street;Work city;London;Work PostCode;Moose vill';
is($node->export_data(),$export,'export_data() - Node returns expected data');

delete $node->{'po_box'};
is($node->export_data(),$export,'export_data() - Node returns expected data, with undef entry');



# Test non-existant methods

