package Text::vCard::Part::Geo;

use strict;

use vars qw($VERSION);
$VERSION = '0.8';

use base qw(Text::vCard::Part);

sub config {
	my %config = (
		'field_names' 		=> ['latitude','longitude'],
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::Geo - Object to handle the Geo part of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head1 METHODS

=head2 latitude()

  my $geo = $vcard->geo();
  my $latitude = $geo->latitude();
  $geo->latitude($latitude);

=head2 longitude()

  my $geo = $vcard->geo();
  my $longitude = $geo->longitude();
  $geo->longitude($longitude);

=cut

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
