package Text::vCard::Part::Name;

use strict;

use vars qw($VERSION);
$VERSION = '0.6';

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

Called without any arguments the following methods return 
a scalar containing the relevant information. This can
be a list seperated by commas.

If supplied with a scalar argument the scalar will be set as
the new value. If supplied with an array ref the values
of the array ref will be joined with a comma and set as
the new value.

=head2 family()

  my $family = $address->family();
  $address->family($family);
  $address->family(\@family);

=head2 given()

  my $given = $address->given();
  $address->given($given);
  $address->given(\@given);
 
 =head2 additional()

  my $additional = $address->additional();
  $address->additional($additional);
  $address->additional(\@additional);
  
=head2 prefixes()

  my $prefixes = $address->prefixes();
  $address->prefixes($prefixes);
  $address->prefixes(\@prefixes);

=head2 suffixes()

  my $suffixes = $address->suffixes();
  $address->suffixes($suffixes);
  $address->suffixes(\@suffixes);     

=cut



=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
