package Text::vCard;

use Carp;

use Text::vCard::Part::Name;
use Text::vCard::Part::Address;

# See this module for your basic parser functions
use base qw(Text::vFile::Base);
use vars qw ( $AUTOLOAD );

# Tell vFile that BEGIN:VCARD line creates one of these objects
$Text::vFile::classMap{'VCARD'}=__PACKAGE__;

=head1 NAME

Text::vCard - a package to parse, edit and create vCards (RFC 2426) 

=head1 SYNOPSIS

    use Text::vCard;
    my $loader = Text::vCard->loader( source => "xmas_card_list.vcf" );

    while (my $vcard = $loader->next) {
        $vcard->....;
    }

    # or even sexier
    
    while (my $vcard = <$loader> ) {
        $vcard->...;
    }

=head1 DESCRIPTION

Still under active development.

=head1 METHODS

=head2 fn()

  my $fn = $vcard->fn();
  
This method will return the full name of the person.

=head2 

=head2 addresses()

	my @addresses = $vcard->addresses();
	my $address_array_ref = $vcard->addresses();
	
This method returns an array or array ref containing 
Text::vCard::Part::Address objects.

TODO: Supply 'types' of addresses required.

=cut

sub addresses {
	my $self = shift;
	
	my @list = @{$self->{ADR}};
	
	return wantarray ? @{$self->{ADR}} : $self->{ADR};	
	
}

=head2 name()

  my $name = $vcard->name();
  
This method returns the Text::vCard::Part::Name object
if available, it returns undef if not.

=cut

sub n {
	my $self = shift;
	if(defined $self->{N}) {
		return $self->{N};	
	}
	return undef;
}

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
		if($varHandler->{$name} eq 'singleText') {
			if($_[1]) {
				$_[0]->{$name}->{value} = $_[1];	
			}
			return $_[0]->{$name}->{value};
			return undef;
		}
	
########## MORE STUFF FOR OTHER TYPES
	} else {
		croak "Unknown method $name";
	}
}	

#### Stuff to make it work!

# This shows mapping of data type based on RFC to the appropriate handler
sub varHandler {

# Handled by a 'part' object
#        'N'           => 'N',
#        'ADR'         => 'ADR',


	return {
        'FN'          => 'singleText',
        'NICKNAME'    => 'multipleText',
        'PHOTO'       => 'singleBinary',
        'BDAY'        => 'singleText',
        'LABEL'       => 'singleTextTyped',
        'TEL'         => 'singleTextTyped',
        'EMAIL'       => 'singleTextTyped',
        'MAILER'      => 'singleText',
        'TZ'          => 'singleText',
        'GEO'         => 'multipleText',
        'TITLE'       => 'singleText',
        'ROLE'        => 'singleText',
        'LOGO'        => 'singleBinary',
        'AGENT'       => 'singleText',
        'ORG'         => 'multipleText',
        'CATEGORIES'  => 'multipleText',
        'NOTE'        => 'singleText',
        'PRODID'      => 'singleText',
        'REV'         => 'singleText',
        'SORT-STRING' => 'singleText',
        'SOUND'       => 'singleBinary',
        'UID'         => 'singleText',
        'URL'         => 'singleText',
        'VERSION'     => 'singleText',
        'CLASS'       => 'singleText',
        'KEY'         => 'singleBinary',
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

# Load the address object
sub load_ADR {

	my $self=shift;
	# This is what an address is based upon
	my $item = $self->SUPER::load_singleTextTyped(@_);

	return Text::vCard::Part::Address->new($item); 

}

# Load the N object
sub load_N {
	my $self=shift;
	my $item = $self->SUPER::load_singleText(@_);
	return Text::vCard::Part::Name->new($item); 
}

=head2 EXPORT

None by default.

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
