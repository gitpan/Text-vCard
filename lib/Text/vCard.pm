package Text::vCard;

use Carp;
use strict;
use Data::Dumper;
use File::Slurp;
use Text::vFile::asData;
use Text::vCard::Node;

# See this module for your basic parser functions
use base qw(Text::vFile::asData);
use vars qw ($VERSION %lookup %node_aliases @simple);
$VERSION = '1.8';

# If the node's data does not break down use this
my @default_field = qw(value);

# If it does use these
%lookup = (
	'ADR' => ['po_box','extended','street','city','region','post_code','country'],
	'N' => ['family','given','middle','prefixes','suffixes'],
	'GEO' => ['lat','long'],
	'ORG' => ['name','unit'],
);

%node_aliases = (
	'FULLNAME' 	=> 'FN',
	'BIRTHDAY'	=> 'BDAY',
	'TIMEZONE'	=> 'TZ',
	'PHONES'	=> 'TELS',
	'ADDRESSES'	=> 'ADR',
	'NAME'		=> 'N',
);

# Generate all our simple methods
@simple = qw(FN BDAY MAILER TZ TITLE ROLE NOTE PRODID REV SORT-STRING UID URL CLASS FULLNAME BIRTHDAY TZ NAME EMAIL NICKNAME PHOTO);
# Now we want lowercase as well
map { push(@simple,lc($_)) } @simple;

# Generate the methods
{
	no strict 'refs';
	no warnings;
        # 'version' handled separately
        # to prevent conflict with ExtUtils::MakeMaker
        # and $VERSION
	for my $node (@simple,"version") { 
		*$node = sub { 
			my ($self,$value) = @_; 
			# See if we have it already
			my $nodes = $self->get($node);
			if(!defined $nodes && $value) {
				# Add it as a node if not exists and there is a value
				$self->add_node({
					'node_type' => $node,
				});
				# Get it out again
				$nodes = $self->get($node);
			}

			if(scalar($nodes) && $value) {
				# Set it
				$nodes->[0]->value($value);
			}
			
			return $nodes->[0]->value() if scalar($nodes);
			return undef;
		}
	    }
}

=head1 NAME

Text::vCard - a package to edit and create a single vCard (RFC 2426) 

=head1 WARNING

You probably want to start with Text::vCard::Addressbook, then this module.

This is not backwards compatable with 1.0 or earlier versions! 

Version 1.1 is a complete rewrite/restructure, this should not happen again.

=head1 SYNOPSIS

  use Text::vCard;
  my $cards = Text::vCard->new({
	'asData_node' => $objects_node_from_asData,
  });

=head1 DESCRIPTION

A vCard is an electronic business card. 

This package is for a single vCard (person / record / set of address information).
It provides an API to editing and creating vCards, or supplied a specific piece
of the Text::vFile::asData results it generates a vCard with that content.

You should really use Text::vCard::Addressbook as this handles creating
vCards from an existing file for you.

=head1 METHODS

=head2 new()

  use Text::vCard;

  my $new_vcard = Text::vCard->new();
  
  my $existing_vcard = Text::vCard->new({
	'asData_node' => $objects_node_from_asData,
  });
  
=cut

sub new {
	my ($proto,$conf) = @_;
	my $class = ref($proto) || $proto;
	my $self = {};

	bless($self,$class);

	if(defined $conf->{'asData_node'}) {
		# Have a vcard data node being passed in
		while(my ($node_type,$data) = each %{$conf->{'asData_node'}}) {
			if($node_type =~ /\./) {
				# Version 3.0 supports group types, we do not
				# so remove everything before '.'
				$node_type =~ s/.+\.(.*)/$1/;
			}
			# Deal with each type (ADR, FN, TEL etc)
			$self->_add_node({
				'node_type' => $node_type,
				'data' => $data,
			});
		}
	} # else we're creating a new vCard

	return $self;
}


=head2 add_node()

my $address = $vcard->add_node({
	'node_type' => 'ADR',
});

This creates a new address in the vCard which you can then call the
address methods on. See below for what options are available.

The node_type parameter must confirm to the vCard spec format (e.g. ADR not address)

=cut

sub add_node {
	my ($self,$conf) = @_;
	croak 'Must supply a node_type' unless defined $conf && defined $conf->{'node_type'};
	unless(defined $conf->{data}) {
		my %empty;
		my @data = (\%empty);
		$conf->{'data'} = \@data;
	}

	$self->_add_node($conf);
}
  
=head2 get()

The following method allows you to extract the contents from the vCard.

  # get all elements
  $nodes = $vcard->get('tels');

  # Just get the home address
  my $nodes = $vcard->get({
	'node_type' => 'addresses',
	'types' => 'home',
  });
  
  # get all phone number that matches serveral types
  my @types = qw(work home);
  my $nodes = $vcard->get({
	'node_type' => 'tels',
	'types' => \@types,
  });
 
Either an array or array ref is returned, containing Text::vCard::Node objects.
If there are no results of 'node_type' undef is returned.

Supplied with a scalar or an array ref the methods
return a list of nodes of a type, where relevant. If any
of the elements is the prefered element it will be
returned as the first element of the list.

=cut

sub get {
	my ($self,$conf) = @_;
	carp "You did not supply an element type" unless defined $conf;
	if(ref($conf) eq 'HASH') {
		return $self->get_of_type($conf->{'node_type'},$conf->{'types'}) if defined $conf->{'types'};
		return $self->get_of_type($conf->{'node_type'});
	} else {
		return $self->get_of_type($conf);
	}
}

=head2 nodes

  my $first_address = ($vcard->get({ 'node_type' => 'address' }))[0];
  
  # get the value
  print $first_address->street();

  # set the value
  $fullname->value('Barney Rubble');
    
According to the RFC the following 'simple' nodes should only have one element, this is
not enforced by this module, so for example you can have multiple URL's if you wish.

=head2 simple nodes

For simple nodes, you can also access the first node in the following way:

  my $fn = $vcard->fullname();
  # or setting
  $vcard->fullname('new name');

The node will be automatically created if it does not exist and you supplied a value.
undef is returned if the node does not exist. Simple nodes can be called as all upper
or all lowercase method names.

  vCard Spec: 'simple'    Alias
  --------------------    --------
  FN                      fullname
  BDAY                    birthday
  MAILER
  TZ                      timezone
  TITLE 
  ROLE 
  NOTE 
  PRODID 
  REV 
  SORT-STRING 
  UID
  URL 
  CLASS
  EMAIL
  NICKNAME
  PHOTO
  version (lowercase only)
  
=head2 more complex vCard nodes

  vCard Spec    Alias           Methods on object
  ----------    ----------      -----------------
  N             name            'family','given','middle','prefixes','suffixes'
  ADR           addresses       'po_box','extended','street','city','region','post_code','country'
  GEO                           'lat','long'
  ORG                           'name','unit'
  TELS          phones
  LABELS

  my $addresses = $vcard->get({ 'node_type' => 'addresses' });
  foreach my $address (@{$addresses}) {
	print $address->street();
  }

  # Setting values on an address element
  $addresses->[0]->street('The burrows');
  $addresses->[0]->region('Wimbeldon common');

  # Checking an address is a specific type
  $addresses->[0]->is_type('fax');
  $addresses->[0]->add_types('home');
  $addresses->[0]->remove_types('work');

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


=head2 get_lookup

This method is used internally to lookup those nodes which have multiple elements,
e.g. GEO has lat and long, N (name) has family, given, middle etc.

If you wish to extend this package (for custom attributes), overload this method
in your code

  sub my_lookup {
		return \%my_lookup;
  }
  *Text::vCard::get_lookup = \&my_lookup;

This has not been tested yet.

=cut 

sub get_lookup {
	my $self = shift;
	return \%lookup;
}

=head2 get_of_type()

  my $list = $vcard->get_of_type($node_type,\@types);

It is probably easier just to use the get() method, which inturn calls
this method.

=cut

# Used to get the right elements
sub get_of_type {
	my ($self, $node_type, $types) = @_;

	# Upper case the name
	$node_type = uc($node_type);

	# See if there is an alias for it
	$node_type = uc($node_aliases{$node_type}) if defined $node_aliases{$node_type};

	return undef unless defined $self->{$node_type};

	if($types) {
		# After specific types
		my @of_type;
		if(ref($types) eq 'ARRAY') {
			@of_type = @{$types};
			#	print "T A: " . join('-',@{$types}) . "\n";
		} else {
			push(@of_type, $types);
			#	print "T: $types\n";
		}
		my @to_return;
		foreach my $element (@{$self->{$node_type}}) {
			my $check = 1; # assum ok for now
			foreach my $type (@of_type) {
				# set it as bad if we don't match				
				$check = 0 unless $element->is_type($type);
			}
			if($check == 1) {
				#	print "Adding: $element->street() \n";
				push(@to_return, $element);
			}
		}
		
		return undef unless scalar(@to_return);
		# Make prefered value first
		@to_return = sort {
			_sort_prefs($b) <=> _sort_prefs($a)
		} @to_return;

		#	print "Returning: " . Dumper(@to_return);

		return wantarray ? @to_return : \@to_return;	
	
	} else {
		# Return them all
		return wantarray ? @{$self->{$node_type}} : $self->{$node_type};	
	}	
}

sub _sort_prefs {
	my $check = shift;
	if($check->is_type('pref')) {
		return 1;
	} else {
		return 0;
	}
}

# Private method for adding nodes
sub _add_node {
	my($self,$conf) = @_;

	my $value_fields = $self->get_lookup();
	
	my $node_type = uc($conf->{node_type});
	$node_type = $node_aliases{$node_type} if defined $node_aliases{$node_type};

	my $field_list;
				
	if(defined $value_fields->{$node_type}) {
		# We know what the field list is
		$field_list = $value_fields->{$node_type};	
	} else {
		# No defined fields - use just the 'value' one
		$field_list = \@default_field;
	}
	unless(defined $self->{$node_type}) {
		# create space to hold list of node objects
		my @node_list_space;
		$self->{$node_type} = \@node_list_space;
	}	
	my $last_node;
	foreach my $node_data (@{$conf->{data}}) {
		my $node_obj = Text::vCard::Node->new({
			node_type => $node_type,
			fields => $field_list,
			data => $node_data,
		});

		push(@{$self->{$node_type}}, $node_obj);
		
		# store the last node so we can return it.
		$last_node = $node_obj;
	}
	return $last_node;
}

=head2 import()

  This is called to create methods at run time. If you want to 
load T:vC at runtime using 'require T:vC' would also have to call 
'import' by hand.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 COPYRIGHT

Copyright (c) 2003 Leo Lapworth. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

Text::vCard::Address, Text::vCard::Node

=cut

1;
