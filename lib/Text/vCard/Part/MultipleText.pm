package Text::vCard::Part::MultipleText;

use strict;

use vars qw($VERSION);
$VERSION = '0.6';

use base qw(Text::vCard::Part);

sub config {
	my %config = (
	);
	return \%config;
}

=head1 NAME

Text::vCard::Part::MultipleText- Object to handle the MultipleText elements
of vCard (nickname, org, categories, geo)

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=cut



=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
