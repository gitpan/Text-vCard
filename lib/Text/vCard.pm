package Text::vCard;

use Text::vCard::Part::Address;
# See this module for your basic parser functions
use base qw(Text::vFile::Base);

# Tell vFile that BEGIN:VCARD line creates one of these objects
$Text::vFile::classMap{'VCARD'}=__PACKAGE__;

=head1 NAME

Text::vCard - a package to parse, edit and create vCards (RFC 2426) 

=SYNOPSIS

    use Text::vCard;
    my $loader = Text::vCard->loader( source => "xmas_card_list.vcf" );

    while (my $vcard = $loader->next) {
        $vcard->....;
    }

    # or even sexier
    
    while (my $vcard = <$loader> ) {
        $vcard->...;
    }

=head1 DESCRIPTION

Still under active development.
    
=cut    
    

# This shows mapping of data type based on RFC to the appropriate handler
sub varHandler {
	return {
        'FN'          => 'singleText',
        'N'           => 'N',
        'NICKNAME'    => 'multipleText',
        'PHOTO'       => 'singleBinary',
        'BDAY'        => 'singleText',
        'ADR'         => 'ADR',
        'LABEL'       => 'singleTextTyped',
        'TEL'         => 'singleTextTyped',
        'EMAIL'       => 'singleTextTyped',
        'MAILER'      => 'singleText',
        'TZ'          => 'singleText',
        'GEO'         => 'multipleText',
        'TITLE'       => 'singleText',
        'ROLE'        => 'singleText',
        'LOGO'        => 'singleBinary',
        'AGENT'       => 'singleText',
        'ORG'         => 'multipleText',
        'CATEGORIES'  => 'multipleText',
        'NOTE'        => 'singleText',
        'PRODID'      => 'singleText',
        'REV'         => 'singleText',
        'SORT-STRING' => 'singleText',
        'SOUND'       => 'singleBinary',
        'UID'         => 'singleText',
        'URL'         => 'singleText',
        'VERSION'     => 'singleText',
        'CLASS'       => 'singleText',
        'KEY'         => 'singleBinary',
	};
};

sub typeDefault {

    return {
        'ADR'     => [ qw(intl postal parcel work) ],
        'LABEL'   => [ qw(intl postal parcel work) ],
        'TEL'     => [ qw(voice) ],
        'EMAIL'   => [ qw(internet) ],
    };

}

sub load_ADR {

	my $self=shift;
	# This is what an address is based upon
	my $item = $self->SUPER::load_singleTextTyped(@_);

	return Text::vCard::Part::Address->new($item); 

}

sub load_N {

	my $self=shift;

	my $item = $self->SUPER::load_singleText(@_);

	# use a hash slice to join the fieldnames with the values in the hash
	my @field_names = ('family','given','middle','prefixes','suffixes');	
	@item{@field_names} = split /,/, $item->{'value'};

	# etc.

}

sub addresses {
	my $self = shift;
	
	my @list = @{$self->{ADR}};
	
	return wantarray ? @{$self->{ADR}} : $self->{ADR};	
	
}

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 COPYRIGHT

Copyright (c) 2003 Leo Lapworth. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS

Jay J. Lawrence for being a fantastic person to bounce ideas
of and for creating Text::vFile from our discussions.

=head1 SEE ALSO

Text::vFile::Base, Text::vFile.

=cut

1;
