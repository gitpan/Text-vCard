package Text::vCard;

use Carp;
use strict;

use Text::vCard::Part::Name;
use Text::vCard::Part::Address;
use Text::vCard::Part::Basic;
use Text::vCard::Part::Binary;
use Text::vCard::Part::Geo;

# See this module for your basic parser functions
use base qw(Text::vFile::Base);
use vars qw ( $AUTOLOAD $VERSION );
$VERSION = '1.0';

# Tell vFile that BEGIN:VCARD line creates one of these objects
$Text::vFile::classMap{'VCARD'}=__PACKAGE__;

=head1 NAME

Text::vCard - a package to parse, edit and create vCards (RFC 2426) 

=head1 SYNOPSIS

  use Text::vCard;
  my $cards = Text::vCard->load( "foo.vCard", "blort.vCard", "whee.vCard" );

  foreach my $vcard (@{$cards}) {
	print "Got card for " . $vcard->fn() . "\n";
  }

=head1 DESCRIPTION

This package provides an API to reading / editing and creating
vCards. A vCard is an electronic business card. This package has
been developed based on rfc2426 which is version 3, we are working
to activly support version 2.1 as well (it works for most stuff other
than 'type' on elements such as tel and address).

You will find that many applications (Apple Address book, MS Outlook,
Evolution etc) can export and import vCards. 

=head1 TODO

- Write out vCards (will be part of Text::vFile).
- Support 'types' on version 2.1 of vCards.
- methods for creating elements.

=head1 READING IN VCARDS

  use Text::vCard;
  my $cards = Text::vCard->load( "foo.vCard", "blort.vCard");

  foreach my $vcard (@{$cards}) {
	$vcard->...;
  }

# OR

  my $reader = Text::vCard->new( source_file => "foo.vCard" );
  while ( my $vcard = $reader->next ) {
	$vcard->...;
  }

# OR

  my $reader = Text::vCard->new( source_text => $vcard_data );
  while ( my $vcard = <$reader> ) {
	$vcard->...;
  }

=head1 GENERAL METHODS

=head2 split_value()

  my @list = $vcard->split_value($value);
  my $list_ref = $vcard->split_value($value);
  
This method splits a value on non-escaped commas;
into an array, or array ref (depending on calling context)
it is useful as some methods (e.g. org and nickname) 
will return the string non-seperated.

=head2 name()

  my $name = $vcard->name();
  
This method returns the Text::vCard::Part::Name object
if available, it returns undef if not.

=cut

sub name {
	my $self = shift;
	if(defined $self->{N}) {
		return $self->{N};	
	}
	return undef;
}

=head1 LIST METHODS

Accessing lists of elements, if no elements
exist then undef is returned.

  my @list = $vcard->method();
  my $list_array_ref = $vcard->method();

Return all of a specific element.

  my @list_of_type = $vcard->method('type');
  my @types = qw(home work pref);
  my @list_of_type = $vcard->method(\@types);

Supplied with a scalar or an array ref the methods
return a list of specific elements of a type. If any
of the elements is the prefered element it will be
returned as the first element of the list.
  
  foreach my $object (@list) {
  	$object->value();
  	$object->value($new_value);
  	$object->is_type('fax');
  	$object->add_type('home');
  	$object->remove_type('work');
  }

Go through each object, then call what ever
methods you want.

=head2 addresses()

This method returns an array or array ref containing 
Text::vCard::Part::Address objects.

=cut

sub addresses {
	my ($self,$types) = @_;
	return $self->_get_of_type('ADR',$types);
}

=head2 tels()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub tels {
	my ($self,$types) = @_;
	return $self->_get_of_type('TEL',$types);
}

=head2 lables()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub lables {
	my ($self,$types) = @_;
	return $self->_get_of_type('LABLE',$types);
}

=head2 emails()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub emails {
	my ($self,$types) = @_;
	return $self->_get_of_type('EMAIL',$types);
}

=head1 SINGLETYPE METHODS

The following list of methods can be accessed as follows:

 my $value = $vcard->method();

Undef will be returned if a value does not exists,
otherwise the value is a scalar.

and can set a new value as follows:

 $vcard->method($value);

=head2 fn()

This method retrieves or sets the full name of the person
associated with the card

=head2 bday()

This method retrieves or sets the birthday of the person
associated with the card.

=head2 mailer()

This method retrieves or sets the type of email software
the person associated with the card uses.

=head2 title()

This method retrieves or sets the title of the person
associated with the card.

=head2 role()

This method retrieves or sets the role of the person
associated with the card based on the X.520 Business Category
explanatory attribute

=head2 note()

This method retrieves or sets a note for the person
associated with the card

=head2 prodid()

This method retrieves or sets the product identifier that
created the vCard

=head2 rev()

This method retrieves or sets the revision (e.g. verson)
of the vcard, of the format date-time or just date. 

=head2 sort-string()

This method retrieves or sets the family name or given name 
text to be used for national-language-specific sorting of 
the fn and name types for the person associated with the card. 

=head2 url()

This method retrieves or sets a single url associated with 
the card.

=head2 version()

This method retrieves or sets the version of the vCard
format used to create the for the card.

=head2 class()

This method retrieves or sets the access classification for
the vCard object

=head1 TYPED SINGLE ELEMENTS METHODS

Accessing lists of elements

  my $object = $vcard->method();
  
  $object->value();
  $object->value($new_value);
  $object->is_type('fax');
  $object->add_type('home');
  $object->remove_type('work');
  
=head2 tz()

Time Zone

=cut

# This doesn't feel right, I'm sure we shouldn't need
# arrays here, but that's what we are getting.

sub tz {
	my $self = shift;
	if(defined $self->{TZ} && defined $self->{TZ}->[0]) {
		return $self->{TZ}->[0];	
	}
	return undef;
}

=head2 uid()

Unique Identifier

=cut

sub uid {
	my $self = shift;
	if(defined $self->{UID} && defined $self->{UID}->[0]) {
		return $self->{UID}->[0];
	}
	return undef;
}

=head1 MULTIPLETEXT METHODS

  my $value = $vcard->method();
  $vcard->method($value);
  $vcard->method(\@value);

The following methods will return a string, containing a
list of values which are comma seperated. They can be altered
by passing in a scalar or an array refernce (this is joined
with commas internally and set as the new value).

=head2 nickname()

Nicknames associated with the person.

=head2 org()

Organisations associated with the person.

=head2 categories()

Categories associated with the person.

=head1 BINARY METHODS

These methods allow access to what are potentially
binary values such as a photo or sound file.

API still to be finalised.

=head2 photo()

=head2 sound()

=head2 key()

=head2 logo()

=cut

#=head1 ADDING ELEMENTS
#my $address = $vcard->address_new({
#	'street' => 'The Street',
#});

#sub address_new {
#	my($self,$conf) = @_;
#	$conf->{'new_object'}
#	return Text::vCard::Part::Address->new($conf); 	
#}


sub DESTROY {
}


sub AUTOLOAD {
	my $name = $AUTOLOAD;
	$name =~ s/.*://;

	croak "No object supplied" unless $_[0];

	# Upper case the name
	$name = uc($name);
	
	my $varHandler = varHandler();
	
	if(defined $varHandler->{$name}) {
		if($varHandler->{$name} eq 'singleText' or $varHandler->{$name} eq 'multipleText' ) {
			if($_[1]) {
				if(ref($_[1]) eq 'ARRAY') {
					$_[0]->{$name}->{value} = join(',', @{$_[1]});
				} else {
					$_[0]->{$name}->{value} = $_[1];
				}
			}
			return $_[0]->{$name}->{value} if defined $_[0]->{$name}->{value};
			return undef;
		} elsif($varHandler->{$name} eq 'singleBinary') {
			# photo etc..
		} 
	} else {
		croak "Unknown method $name";
	}
}	

# methods for Text::vFile - to make it work!

# This shows mapping of data type based on RFC to the appropriate handler
sub varHandler {

	return {
        'FN'          => 'singleText',
        'BDAY'        => 'singleText',
        'MAILER'      => 'singleText',
        'TITLE'       => 'singleText',
        'ROLE'        => 'singleText',
        'NOTE'        => 'singleText',
        'PRODID'      => 'singleText',
        'REV'         => 'singleText',
        'SORT-STRING' => 'singleText',
        'URL'         => 'singleText',
        'VERSION'     => 'singleText',
        'CLASS'       => 'singleText',
	};
};

# If the part has default types and none it self use them.
sub typeDefault {

    return {
        'ADR'     => [ qw(intl postal parcel work) ],
        'LABEL'   => [ qw(intl postal parcel work) ],
        'TEL'     => [ qw(voice) ],
        'EMAIL'   => [ qw(internet) ],
    };

}

sub load_ADR {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Address->new($item); 
}

sub load_N {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Name->new($item); 
}

sub load_GEO {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Geo->new($item); 
}

sub load_NICKNAME {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_ORG {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_CATEGORIES {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_TEL {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_LABLE {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_EMAIL {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_TZ {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_UID {
	my $self=shift;
	my $item = $self->SUPER::load_singleTextTyped(@_);
	return Text::vCard::Part::Basic->new($item); 
}

sub load_PHOTO {
	my $self=shift;
	my $item = $self->SUPER::load_singleBinary(@_);
	return Text::vCard::Part::Binary->new($item); 
}

sub load_SOUND {
	my $self=shift;
	my $item = $self->SUPER::load_singleBinary(@_);
	return Text::vCard::Part::Binary->new($item); 
}

sub load_KEY {
	my $self=shift;
	my $item = $self->SUPER::load_singleBinary(@_);
	return Text::vCard::Part::Binary->new($item); 
}

sub load_LOGO {
	my $self=shift;
	my $item = $self->SUPER::load_singleBinary(@_);
	return Text::vCard::Part::Binary->new($item); 
}

# Used to get the right elements
sub _get_of_type {
	my ($self, $element_type, $types) = @_;
	
	return undef unless defined $self->{$element_type};

	if($types) {
		# After specific types
		my @of_type;
		if(ref($types) eq 'ARRAY') {
			@of_type = @{$types};
		} else {
			push(@of_type, $types);
		}
		my @to_return;
		foreach my $element (@{$self->{$element_type}}) {
			my $check = 1; # assum ok for now
			foreach my $type (@of_type) {
				# set it as bad if we don't match
				$check = 0 unless $element->is_type($type);
			}
			if($check == 1) {
				push(@to_return, $element);
			}
		}
		
		return undef unless scalar(@to_return);
		
		# Make prefered value first
		@to_return = sort {
			$b->is_pref() <=> $a->is_pref()
		} @to_return;

		return wantarray ? @to_return : \@to_return;	
	
	} else {
		# Return them all
		return wantarray ? @{$self->{$element_type}} : $self->{$element_type};	
	}	
}

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 COPYRIGHT

Copyright (c) 2003 Leo Lapworth. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS

Jay J. Lawrence for being a fantastic person to bounce ideas
off and for creating Text::vFile from our discussions.

=head1 SEE ALSO

Text::vFile::Base, Text::vFile, Text::vCard::Part::Address, Text::vCard::Part::Name,
Text::vCard::Part::Basic, Text::vCard::Part::Binary, Text::vCard::Part::Geo

=cut

1;
