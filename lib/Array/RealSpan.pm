package Array::RealSpan;

# ABSTRACT: Map real number ranges to labels or objects

our $VERSION = '0.01';

use strict;
use warnings;
use Carp qw(croak);

use Moo;

=head1 NAME

Array::RealSpan - Map real number ranges to labels or objects

=head1 SYNOPSIS

  use Array::RealSpan;
  my $epoch = Array::RealSpan->new;
  $epoch->set_range(  0,     0.01, 'Holocene' );
  $epoch->set_range(  0.01,  1.81, 'Pliestocene' );
  $epoch->set_range(  1.81,  5.32, 'Pliocene' );
  $epoch->set_range(  5.32, 23.8,  'Miocene' );
  $epoch->set_range( 23.8,  33.7,  'Oligocene' );
  $epoch->set_range( 33.7,  55,    'Eocene' );
  $epoch->set_range( 55,    65,    'Paleocene' );
  my $name = $epoch->lookup(3.14);
  my $range = $epoch->get_range('Holocene');

=head1 DESCRIPTION

An C<Array::RealSpan> object maps real number ranges to associated labels.

=head1 METHODS

=head2 new

  $span = Array::RealSpan->new;

Create a new C<Array::RealSpan> object.

=cut

has _ranges => (
    is      => 'rw',
    default => sub { [] },
);

=head2 set_range

  $span->set_range( $start, $end, $label );

Add a range, from start to end, for a given label.

=cut

sub set_range {
    my ( $self, $start, $end, $label ) = @_;

    croak('set_range() should be called with 3 values.')
        unless defined $start && defined $end && defined $label;
    croak("set_range() called with bad indices: $start, $end")
        if $end <= $start;

    push @{ $self->_ranges }, [ $start, $end, $label ];
}

=head2 get_range

  $range = $span->get_range($label);

Return the range for the given label.

=cut

sub get_range {
    my ( $self, $label ) = @_;
    my $get_range;
    for my $range ( @{ $self->_ranges } ) {
        if ( $label eq $range->[2] ) {
            $get_range = [ $range->[0], $range->[1] ];
            last;
        }
    }
    return $get_range;
}

=head2 lookup

  $label = $span->lookup($number);

Look up the label for the range containing the given number.

This compares each range by considering the number less than or equal to the
start and less than the end.

=cut

sub lookup {
    my ( $self, $number ) = @_;
    my $lookup;
    for my $range ( @{ $self->_ranges } ) {
        if ( $number >= $range->[0] && $number < $range->[1] ) {
            $lookup = $range->[2];
            last;
        }
    }
    return $lookup;
}

1;
__END__

=head1 SEE ALSO

See L<Array::IntSpan> for a more featured implementation (but for integer ranges
only).

=cut
