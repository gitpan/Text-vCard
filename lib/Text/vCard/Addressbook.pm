package Text::vCard::Addressbook;

use Carp;
use strict;
use Data::Dumper;
use File::Slurp;
use Text::vFile::asData;
use Text::vCard;

# See this module for your basic parser functions
use base qw(Text::vFile::asData);
use vars qw ($VERSION);
$VERSION = '1.4';

=head1 NAME

Text::vCard::Addressbook - a package to parse, edit and create multiple vCards (RFC 2426) 

=head1 SYNOPSIS

  use Text::vCard::Addressbook;

  my $address_book = Text::vCard::Addressbook->new({
	'source_file' => '/path/to/address.vcf',
  });

  foreach my $vcard ($address_book->vcards()) {
  	my @full_name = $vcard->get('fn');
	print "Got card for " . $full_name[0] . "\n";
  }

=head1 DESCRIPTION

This package provides an API to reading / editing and creating
multiple vCards. A vCard is an electronic business card. This package has
been developed based on rfc2426.

You will find that many applications (Apple Address book, MS Outlook,
Evolution etc) can export and import vCards. 

=head1 READING IN VCARDS


=head2 load()

  use Text::vCard::Addressbook;

  # Read in from a list of files
  my $address_book = Text::vCard::Addressbook->load( ['foo.vCard', 'Addresses.vcf']);

This method will croak if it is unable to read in any of the files.

=cut

sub load {
	my ($proto,$files) = @_;

	my $self = __PACKAGE__->new();
	
	foreach my $file (@{$files}) {
		croak "Unable to read file $file\n" unless -r $file;
		$self->_process_text(scalar read_file($file));
	}

	return $self;
	
}

=head2 new()
  
  # Read in from just one file
  my $address_book = Text::vCard::Addressbook->new({
	'source_file' => '/path/to/address.vcf',
  });

This method will croak if it is unable to read in the source_file.

  # File already in a string
  my $address_book = Text::vCard::Addressbook->new({
	'source_text' => $source_text,
  });

  # Create a new address book
  my $address_book = Text::vCard::Addressbook->new();

Looping through all vcards in an address book.
  
  foreach my $vcard ($address_book->vcards()) {
	$vcard->...;
  }
  
=cut

sub new {
	my ($proto,$conf) = @_;
	my $class = ref($proto) || $proto;
	my $self = {};

	if(defined $conf->{'source_file'}) {
		# Need to read in source file
		croak "Unable to read file $conf->{'source_file'}\n" unless -r $conf->{'source_file'};
		$conf->{'source_text'} = read_file($conf->{'source_file'});
	}

	# create some where to store out individual vCard objects
	my @cards;
	$self->{'cards'} = \@cards;

	bless($self,$class);

	# Process the text if we have it.
	$self->_process_text($conf->{'source_text'}) if defined $conf->{'source_text'};
	
	return $self;
}

=head1 METHODS

=head2 add_vcard()

  my $vcard = $address_book->add_vcard();

This method creates a new empty Text::vCard object, stores it in the
address book and return it so you can add data to it.

=cut

sub add_vcard {
	my $self = shift;
	my $vcard = Text::vCard->new();
	push(@{$self->{cards}}, $vcard);
	return $vcard;
}


=head2 vcards()

  my $vcards = $address_book->vcards();
  my @vcards = $address_book->vcards();

This method returns a reference to an array or an array of
vcards in this address book. This could be an empty list
if there are no entries in the address book.

=cut

sub vcards {
	my $self = shift;
	return wantarray ? @{$self->{cards}} : $self->{cards};
}

=head2 export_vcf

  my $vcf_file = $address_book->export()

This method doesn't exist yet.

=cut

sub export_vcf {
	my $self = shift;
	print "Oi - I said this method doesn't exist yet!\n";
}


# PRIVATE METHODS

# Process a chunk of text, create Text::vCard objects and store in the address book
sub _process_text {
	my($self,$text) = @_;

	# As data may handle \r - must ask richard
	$text =~ s/\r//g;

	# Add error checking here ?
	my $data = Text::vFile::asData->new->parse_lines(split("\n",$text));
	
	foreach my $card (@{$data->{'objects'}}) {
		# Run through each card in the data
		if($card->{'type'} eq 'VCARD') {
			my $vcard = Text::vCard->new({
				'asData_node' => $card->{'properties'},
			});
			push(@{$self->{'cards'}},$vcard);
		} else {
			carp "This file contains $card->{'type'} data which was not parsed\n";
		}
	}

	
}

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 COPYRIGHT

Copyright (c) 2003 Leo Lapworth. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS

The authors of Text::vFile::asData for making my life so much easier.

=head1 SEE ALSO

Text::vCard, Text::vCard::Node

=cut

1;
