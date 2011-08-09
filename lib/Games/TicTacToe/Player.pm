package Games::TicTacToe::Player;

use Mouse;
use Mouse::Util::TypeConstraints;

use Carp;
use Data::Dumper;

=head1 NAME

Games::TicTacToe::Player - Interface to the TicTacToe game's player.

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';

=head1 DESCRIPTION

The module used by the parent module Games::TicTacToe.

=cut

type 'Symbol' => where { (/^[X|O]$/i) };
type 'Player' => where { (/^[H|C]$/i) };

has 'type'   => (is => 'ro', isa => 'Player', default => 'H', required => 1);
has 'symbol' => (is => 'ro', isa => 'Symbol', default => 'X', required => 1);

=head1 METHODS

=head2 otherSymbol()

Returns opposition player's symbol.

=cut

sub otherSymbol
{
    my $self = shift;
    return ($self->symbol eq 'X')?('O'):('X');
}

=head2 desc()

Returns the description of the player.

=cut

sub desc
{
    my $self = shift;
    return ($self->{type} eq 'H')?('Human'):('Computer');
}

=head2 getMessage()

Returns the winning message for the player.

=cut

sub getMessage
{
    my $self = shift;
    return sprintf("Congratulation, %s won the game.\n", $self->desc);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-tictactoe at rt.cpan.org> or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>. I will 
be notified & then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::TicTacToe::Player

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-TicTacToe>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-TicTacToe>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-TicTacToe>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-TicTacToe/>

=back

=head1 LICENSE AND COPYRIGHT

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Mouse; # Keywords are removed from the Games::TicTacToe::Player package
no Mouse::Util::TypeConstraints;

1; # End of Games::TicTacToe::Player