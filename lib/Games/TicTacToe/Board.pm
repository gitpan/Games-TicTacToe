package Games::TicTacToe::Board;

$Games::TicTacToe::Board::VERSION = '0.06';

=head1 NAME

Games::TicTacToe::Board - Interface to the TicTacToe game's board.

=head1 VERSION

Version 0.06

=cut

use 5.006;
use Data::Dumper;

use Moo;
use namespace::clean;

our $EMPTY = '\d';

=head1 DESCRIPTION

The module used by the parent module Games::TicTacToe.

=cut

has 'cell' => (is => 'rw', default => sub { return ['1','2','3','4','5','6','7','8','9']; });

=head1 METHODS

=head2 isFull()

Return 1 or 0 depending whether the game board is full or not.

=cut

sub isFull {
    my ($self) = @_;

    foreach (0..8) {
        return 0 if $self->_isCellEmpty($_);
    }

    return 1;
}

=head2 setCell()

Set the cell with the player symbol.

=cut

sub setCell {
    my ($self, $index, $symbol) = @_;

    die("ERROR: Missing cell index for TicTacToe Board.\n")       unless defined $index;
    die("ERROR: Missing symbol for TicTacToe Board.\n")           unless defined $symbol;
    die("ERROR: Invalid cell index value for TicTacToe Board.\n") unless ($index  =~ /^[0-8]$/);
    die("ERROR: Invalid symbol for TicTacToe Board.\n")           unless ($symbol =~ /^[X|O]$/i);

    $self->{cell}->[$index] = $symbol;
}

=head2 getCell()

Get the cell symbol in the given index.

=cut

sub getCell {
    my ($self, $index) = @_;

    die("ERROR: Missing cell index for TicTacToe Board.\n")  unless defined($index);
    die("ERROR: Invalid index value for TicTacToe Board.\n") unless (($index >= 0) && ($index <= 8));

    return $self->{cell}->[$index];
}

=head2 as_string()

Returns the current game board.

=cut

sub as_string {
    my ($self) = @_;

    my $board = sprintf("+-----------+\n");
    $board .= sprintf("| TicTacToe |\n");
    $board .= sprintf("+---+---+---+\n");
    foreach my $row (1..3) {
        foreach my $col (1..3) {
            $board .= sprintf("| %s ", $self->_getCellRowCol($row, $col));
        }
        $board .= sprintf("|\n+---+---+---+\n");
    }

    return $board;
}

#
#
# PRIVATE METHODS

sub _getCellRowCol {
    my ($self, $row, $col) = @_;

    die("ERROR: Missing row/col value for TicTacToe Board.\n")
        unless (defined($row) && defined($col));
    die("ERROR: Invalid value for row/col for TicTacToe Board.\n")
        unless (($row >= 1) && ($row <= 3) && ($col >= 1) && ($col <= 3));

    my $index = ($row == 1)?(0):(($row == 2)?(3):(6));
    return $self->getCell(($index+$col)-1);
}

sub _isCellEmpty {
    my ($self, $index) = @_;

    return 1 if ($self->getCell($index) =~ /$EMPTY/);
    return 0;
}

sub _availableIndex {
    my ($self) = @_;

    my $index = '';
    foreach (1..9) {
        $index .= $_ . "," if $self->_isCellEmpty($_-1);
    }
    $index =~ s/\,$//g;

    return $index;
}

sub _belongsToPlayer {
    my ($self, $cells, $player) = @_;

    return 1
        if ($self->_cellContains($cells->[0], $player->symbol)
            &&
            $self->_cellContains($cells->[1], $player->symbol)
            &&
            $self->_cellContains($cells->[2], $player->symbol));
    return 0;
}

sub _cellContains {
    my ($self, $index, $symbol) = @_;

    return 1 if ($self->getCell($index) eq $symbol);
    return 0;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 REPOSITORY

L<https://github.com/Manwar/Games-TicTacToe>

=head1 BUGS

Please report any bugs / feature requests to C<bug-games-tictactoe at rt.cpan.org>
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>.
I will be notified & then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::TicTacToe::Board

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

This  program  is  free software; you can redistribute it and/or modify it under
the  terms  of the the Artistic License (2.0). You may obtain a copy of the full
license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any  use,  modification, and distribution of the Standard or Modified Versions is
governed by this Artistic License.By using, modifying or distributing the Package,
you accept this license. Do not use, modify, or distribute the Package, if you do
not accept this license.

If your Modified Version has been derived from a Modified Version made by someone
other than you,you are nevertheless required to ensure that your Modified Version
 complies with the requirements of this license.

This  license  does  not grant you the right to use any trademark,  service mark,
tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge patent license
to make,  have made, use,  offer to sell, sell, import and otherwise transfer the
Package with respect to any patent claims licensable by the Copyright Holder that
are  necessarily  infringed  by  the  Package. If you institute patent litigation
(including  a  cross-claim  or  counterclaim) against any party alleging that the
Package constitutes direct or contributory patent infringement,then this Artistic
License to you shall terminate on the date that such litigation is filed.

Disclaimer  of  Warranty:  THE  PACKAGE  IS  PROVIDED BY THE COPYRIGHT HOLDER AND
CONTRIBUTORS  "AS IS'  AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES. THE IMPLIED
WARRANTIES    OF   MERCHANTABILITY,   FITNESS   FOR   A   PARTICULAR  PURPOSE, OR
NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY YOUR LOCAL LAW. UNLESS
REQUIRED BY LAW, NO COPYRIGHT HOLDER OR CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE
OF THE PACKAGE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of Games::TicTacToe::Board
