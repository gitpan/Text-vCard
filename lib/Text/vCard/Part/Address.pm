package Text::vCard::Part::Address;

use strict;

use base qw(Text::vCard::Part);

sub config {
	my %config = (
		'field_names' 		=> ['pobox','extad','street','locality','region','pcode','country'],
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::Address - Object to handle the address parts of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head1 METHODS

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

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
