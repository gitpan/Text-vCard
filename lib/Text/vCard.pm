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
$VERSION = '0.7';

# Tell vFile that BEGIN:VCARD line creates one of these objects
$Text::vFile::classMap{'VCARD'}=__PACKAGE__;

=head1 NAME

Text::vCard - a package to parse, edit and create vCards (RFC 2426) 

=head1 IMPORTANT

The API is currently subject to change, so don't rely on it being
the same in the next version! Some documented functionality is still
under development as well, basically have a look if your interested
but give me a few weeks to get a finished version out!

=head1 SYNOPSIS

  use Text::vCard;
  my $loader = Text::vCard->loader( source => "xmas_card_list.vcf" );

  while (my $vcard = $loader->next) {
    $vcard->....;
  }

or even sexier

  while (my $vcard = <$loader> ) {
    $vcard->...;
  }

See Text::vCard for more options, such as parsing a string.

=head1 DESCRIPTION

Still under active development.

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

Accessing lists of eliments

  my @list = $vcard->method();
  my $list_array_ref = $vcard->method();
  
  foreach my $object (@list) {
  	$object->value();
  	$object->value($new_value);
  	$object->is_type('fax');
  	$object->add_type('home');
  	$object->remove_type('work');
  }

TODO: specify type(s) if required, adding new eliments

=head2 addresses()

This method returns an array or array ref containing 
Text::vCard::Part::Address objects.

=cut

sub addresses {
	my $self = shift;
	
	return undef unless defined $self->{ADR};
	
	return wantarray ? @{$self->{ADR}} : $self->{ADR};	
}

=head2 tels()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub tels {
	my $self = shift;
	
	return undef unless defined $self->{TEL};
	
	return wantarray ? @{$self->{TEL}} : $self->{TEL};	
}

=head2 lables()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub lables {
	my $self = shift;
	
	return undef unless defined $self->{LABLE};
	
	return wantarray ? @{$self->{LABLE}} : $self->{LABLE};	
}

=head2 emails()
	
This method returns an array or array ref containing 
Text::vCard::Part::Basic objects.

=cut

sub emails {
	my $self = shift;
	
	return undef unless defined $self->{EMAIL};
	
	return wantarray ? @{$self->{EMAIL}} : $self->{EMAIL};	
}

=head1 SINGLETYPE METHODS

The following list of methods can be accessed as follows:

 my $value = $vcard->method();

Undef will be returned if a value does not exists.

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


=head1 TYPED SINGLE ELIMENTS METHODS

Accessing lists of eliments

  my $object = $vcard->method();
  
  $object->value();
  $object->value($new_value);
  $object->is_type('fax');
  $object->add_type('home');
  $object->remove_type('work');
  
=head2 tz()

Time Zone

=cut

sub tz {
	my $self = shift;
	if(defined $self->{TZ}) {
		return $self->{TZ};	
	}
	return undef;
}

=head2 uid()

Unique Identifier

=cut

sub uid {
	my $self = shift;
	if(defined $self->{UID}) {
		return $self->{UID};	
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

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 COPYRIGHT

Copyright (c) 2003 Leo Lapworth. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS

Jay J. Lawrence for being a fantastic person to bounce ideas
of and for creating Text::vFile from our discussions.

=head1 SEE ALSO

Text::vFile::Base, Text::vFile, Text::vCard::Part::Address, Text::vCard::Part::Name.

=cut

1;
