package Text::vCard::Part::Address;

use strict;

use base qw(Text::vCard::Part);

sub config {
	my %config = (
		'field_names' 		=> ['po_box','extended','street','city','region','post_code','country'],
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::Address - Object to handle the address parts of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head1 ADDRESS DETAIL METHODS

Called without any arguments the following methods return 
a scalar containing the relevant information. This can
be a list seperated by commas.

If supplied with a scalar argument the scalar will be set as
the new value. If supplied with an array ref the values
of the array ref will be joined with a comma and set as
the new value.

=head2 po_box()

  my $po_box = $address->po_box();
  $address->po_box($po_box);
  $address->po_box(\@po_boxes);


=head2 extended()

  my $extended = $address->extended();
  $address->extended($extended);
  $address->extended(\@extendedes);

=head2 street()

  my $street = $address->street();
  $address->street($street);
  $address->street(\@streetes);

=head2 city()

  my $city = $address->city();
  $address->city($city);
  $address->city(\@cityes);

=head2 region()

  my $region = $address->region();
  $address->region($region);
  $address->region(\@regiones);

=head2 post_code()

  my $post_code = $address->post_code();
  $address->post_code($post_code);
  $address->post_code(\@post_codees);

=head2 country()

  my $country = $address->country();
  $address->country($country);
  $address->country(\@countryes);

=head1 OTHER METHODS

=head2 types()

	my @types = $address->types();
	or
	my $types = $address->types();
	
This method will return an array or an array ref depending
on the calling context. This contains the types associated
with this address.

The types can include:
"dom" to indicate a domestic delivery address
"intl" to indicate an international delivery address
"postal" to indicate a postal delivery address
"parcel" to indicate a parcel delivery address
"home" to indicate a delivery address for a residence
"work" to indicate delivery address for a place of work
"pref" to indicate the preferred delivery address when more 
than one address is specified. 


=head2 is_type()

  if($address->is_type($type) {
  	# ...
  }
  
Given a type (see types() for a list of possibilities)
this method returns 1 if the address is of that type
or undef if it is not.

=head2 add_type()

  $address->add_type('home');

Add a type to an address.

=head2 remove_type()

  $address->remove_type('home');

This method removes a type from an address.


=head1 STILL TO IMPLIMENT

# These can take a scalar or an array, return the 'pref' if possible or the right order.


foreach my $address ( $card->addresses(['home','postal']) {
	$address->boo;
}
- and/or -
foreach my $address ( $card->addresses('home') {
	$address->boo;
}

@all_addresss = $card->addresses;
@pref_addresses = $card->address( 'pref' );
@spam_addresses = $card->address( 'home', 'work', 'intl' );

	print "Street address for " . $address->type . " is " . $address->street . "\n";
This wouldn't work, an address could have more than 1 type so should return
an array. Do you mean:

print "Street address for " . join(", ", $address->types()) . " is " . $address->street . "\n";

$card->address_new(
	'street' => "74 Bayswater",
	'city' => "Ottawa",
	'type' => [ 'home', 'work' ],
);

# Long form:
my $new_address = $card->address_new;
$new_address->street( "74 Bayswater" );
$new_address->city("ottawa");
....

=cut

=head1 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
