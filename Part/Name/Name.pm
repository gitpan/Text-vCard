package Text::vCard::Part::Name;

use strict;

use base qw(Text::vCard::Part);

my $VERSION = '0.02';


sub config {
	my %config = (
		'field_names' 		=> ['pobox','extad','street','locality','region','pcode','country'],
	);
	return \%config;
}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Text::vCard::Part::Name - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Text::vCard::Part::Name;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Text::vCard::Part::Name, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.


=head1 AUTHOR

A. U. Thor, a.u.thor@a.galaxy.far.far.away

=head1 SEE ALSO

perl(1).

=cut
