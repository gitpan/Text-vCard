package Text::vCard::Part;

use strict;
my $VERSION = '0.02';

sub new {
	my ($proto,$item) = @_;
    my $class = ref($proto) || $proto;

    bless($item, $class);


	if($item->can('config')) {
		my $conf = $item->config();
		# If there are field names apply them
		if(defined $conf->{'field_names'}) {
			@{$item}{@{$conf->{'field_names'}}} = split(/;/, $item->{'value'});
		}
	}


	return $item;
}

=head2 types()

	my @types = $part->types();
	or
	my $types = $part->types();
	
This method will return an array or an array ref depending
on the calling context of types associated with the $part.

=cut 

sub types {
	my $self = shift;
	my @types;
	@types = keys %{$self->{type}};# if defined $self->{type};
	return wantarray ? @types : \@types;
}

=head2 is_type()

  if($part->is_type($type) {
  	# ...
  }
  
Given a type (see types() for a list of possibilities)
this method returns 1 if the $part is of that type
or undef if it is not.

=cut 

sub is_type {
	my($self,$type) = @_;
	if(defined $self->{type} && defined $self->{type}->{$type}) {
		return 1;
	}
	return undef;
}

=head2 add_type()

 $address->add_type('home');

Add a type to an address.

=cut

sub add_type {
	my($self, $type) = @_;
	$self->{type}->{$type} = 1 if defined $self->{type};
}


=head2 remove_type()

  $address->remove_type('home');

This method removes a type from an address.

=cut

sub remove_type {
	my($self, $type) = @_;
	delete $self->{type}->{$type} if defined $self->{type} && $self->{type}->{$type};

}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

Text::vCard::Part - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Text::vCard::Part;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Text::vCard::Part, created by h2xs. It looks like the
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
