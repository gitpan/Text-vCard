package Text::vCard::Part::Name;

use strict;

use vars qw($VERSION);
$VERSION = '0.9';

use base qw(Text::vCard::Part);

sub config {
	my %config = (
		'field_names' 		=> ['family','given','additional','prefixes','suffixes'],
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::Name - Object to handle the name part of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head1 NAME DETAIL METHODS

  my $value = $adddress->method();
  $address->method($value);
  $address->method(\@value);

Called without any arguments the following methods return 
a scalar containing the relevant information. This can
be a list seperated by commas.

If supplied with a scalar argument the scalar will be set as
the new value. If supplied with an array ref the values
of the array ref will be joined with a comma and set as
the new value.

=head2 family()

=head2 given()
 
=head2 additional()
  
=head2 prefixes()

=head2 suffixes()

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
