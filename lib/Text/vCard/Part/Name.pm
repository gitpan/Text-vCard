package Text::vCard::Part::Name;

use strict;

use base qw(Text::vCard::Part);

sub config {
	my %config = (
		'field_names' 		=> ['pobox','extad','street','locality','region','pcode','country'],
	);
	return \%config;
}
=head1 NAME

Text::vCard::Part::Name - Object to handle the name part of a vCard

=head1 DESCRIPTION

You should not need to access this object directly it will be created as
required when you parse a vCard. - not fully implimented!

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;
