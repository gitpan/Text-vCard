package Text::vCard::Part::Binary;

use strict;

use vars qw($VERSION);
$VERSION = '0.9';

use base qw(Text::vCard::Part);

sub config {
	my %config = (
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::Binary - Object to handle the binary parts of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head1 ADDRESS DETAIL METHODS

my $value = $address->method();
$address->method($value);
$address->method(\@values);

Called without any arguments the following methods return 
a scalar containing the relevant information. This can
be a list seperated by commas.

If supplied with a scalar argument the scalar will be set as
the new value. If supplied with an array ref the values
of the array ref will be joined with a comma and set as
the new value.

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

=cut

=head1 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
