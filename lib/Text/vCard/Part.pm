package Text::vCard::Part;

use strict;
my $VERSION = '0.02';

=head1 NAME

Text::vCard::Part - Parent object to handle several parts of a vCard

=head1 

	package YOUR_PACKAGE_NAME_HERE;
	use base qw(Text::vCard::Part);

	sub config {
		my %config = (
			# If the package refers to a part with multipul values
			'field_names' 		=> ['pobox','extad',...],
		);
		return \%config;
	}

=head1 DESCRIPTION

This package can be inherited from when additional parts of a vCard
need to become objects, such as Address and Name. The created objects
are called from Text::vCard so this probably isn't something you
want to do unless your helping maintain Text::vCard as well!

=head1 METHODS

=cut

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

=head2 EXPORT

None by default.

=head1 AUTHOR

Leo Lapworth, LLAP@cuckoo.org

=head1 SEE ALSO

Text::vCard.

=cut

1;

