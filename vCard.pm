package Text::vCard;

use Text::vCard::Part::Address;
# See this module for your basic parser functions
use base qw(Text::vFile::Base);

my $VERSION = '0.02';

# Tell vFile that BEGIN:VCARD line creates one of these objects
$Text::vFile::classMap{'VCARD'}=__PACKAGE__;

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


1;
