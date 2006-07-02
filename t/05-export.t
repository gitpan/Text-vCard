#!/usr/bin/perl -w

use strict;

use blib;

use Test::More tests => 4;

use Data::Dumper;
# Check we can load module
BEGIN { use_ok( 'Text::vCard::Addressbook' ); }

local $SIG{__WARN__} = sub { die $_[0] };

my @data = (
	'BEGIN:VCARD',
	'item1.X-ABADR:uk',
	'item2.X-ABADR:uk',
	'N:T-surname;T-first;;;',
	'TEL;pref;home:020 666 6666',
	'TEL;cell:0777 777 7777',
	'item2.ADR;work:;;Test Road;Test City;;Test Postcode;Test Country',
	'item1.ADR;pref;home:;;Pref Test Road;Pref Test City;;Pref Test Postcode;Pref Test Country',
	'VERSION:3.0',
	'FN:T-firstname T-surname',
	'END:VCARD',
);

#######
# Test new()
#######
my $adbk = Text::vCard::Addressbook->new({ 'source_file' => 't/apple_version3.vcf'});

my $vcf = $adbk->export();
my @lines = split("\r\n",$vcf);

is($lines[0],'BEGIN:VCARD','export() - First line correct');
is($lines[$#lines],'END:VCARD','export() - Last line correct');

#is_deeply(\@lines,\@data,'export() - returned data matched that expected');

#my $notes = Text::vCard::Addressbook->new({ 'source_file' => 't/notes.vcf'});
#print Dumper($notes);
#my $res = $notes->export();
#print Dumper($res);






