package Games::TicTacToe::Move;

$Games::TicTacToe::Move::VERSION = '0.06';

=head1 NAME

Games::TicTacToe::Move - Interface to the TicTacToe game's move.

=head1 VERSION

Version 0.06

=cut

use 5.006;
use Data::Dumper;

$SIG{'INT'} = sub {
    print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1);
};

our $BEST_MOVE    = [4, 0, 2, 6, 8];
our $WINNING_MOVE = [ [0, 1, 2],
                      [0, 3, 6],
                      [0, 4, 8],
                      [1, 4, 7],
                      [2, 5, 8],
                      [2, 4, 6],
                      [3, 4, 5],
                      [6, 7, 8],
                    ];

=head1 DESCRIPTION

It is used internally by L<Games::TicTacToe>.

=head1 METHODS

=head2 foundWinner()

Return 1 or 0 depending wether we have a winner or not.

=cut

sub foundWinner {
    my ($player, $board) = @_;

    die("ERROR: Player not defined.\n") unless defined $player;
    die("ERROR: Board not defined.\n")  unless defined $board;

    foreach my $move (@$WINNING_MOVE) {
        return 1 if $board->_belongsToPlayer($move, $player);
    }

    return 0;
}

=head2 now()

Make a move now for the current player.

=cut

sub now {
    my ($player, $board) = @_;

    die("ERROR: Player not defined.\n") unless defined $player;
    die("ERROR: Board not defined.\n")  unless defined $board;

    if ($player->type eq 'H') {
        return _humanMove($board);
    }
    else {
        return _computerMove($board, $player);
    }
}

#
#
# PRIVATE METHODS

sub _humanMove {
    my ($board) = @_;

    die("ERROR: Board not defined.\n") unless defined $board;

    return _validate_human_move($board);
}

sub _computerMove {
    my ($board, $player) = @_;

    die("ERROR: Board not defined.\n") unless defined $board;

    my $move = _getBestMove($board, $player);
    return $move unless ($move == -1);

    foreach (@$BEST_MOVE) {
        return $_ if $board->_isCellEmpty($_);
    }

    foreach (0..8) {
        return $_ if $board->_isCellEmpty($_);
    }
}

sub _getBestMove {
    my ($board, $player) = @_;

    my $move = _isWinningMove($board, $player->symbol);
    return $move unless ($move == -1);
    return _isWinningMove($board, $player->otherSymbol());
}

sub _isWinningMove {
    my ($board, $symbol) = @_;

    foreach (@{$WINNING_MOVE}) {
        return $_->[0]
            if ($board->_isCellEmpty($_->[0])
                && $board->_cellContains($_->[1], $symbol)
                && $board->_cellContains($_->[2], $symbol));

        return $_->[1]
            if ($board->_isCellEmpty($_->[1])
                && $board->_cellContains($_->[0], $symbol)
                && $board->_cellContains($_->[2], $symbol));

        return $_->[2]
            if ($board->_isCellEmpty($_->[2])
                && $board->_cellContains($_->[0], $symbol)
                && $board->_cellContains($_->[1], $symbol));
    }

    return -1;
}

sub _validate_human_move {
    my ($board) = @_;

    die("ERROR: Board not defined.\n") unless defined $board;

    print {*STDOUT} "What is your next move [".$board->_availableIndex()."]? ";
    my $move = <STDIN>;
    chomp($move);
    return _validate_move($move, $board);
}

sub _validate_move {
    my ($move, $board) = @_;

    die("ERROR: Board not defined.\n") unless defined $board;

    while (!(defined($move)
             && ($move =~ /^[1-9]$/)
             && ($move >= 1) && ($move <= 9)
             && ($board->_isCellEmpty($move-1)))) {
        print {*STDOUT} "Please make a valid move [".$board->_availableIndex()."]: ";
        $move = <STDIN>;
        chomp($move);
    }

    return ($move-1);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 REPOSITORY

L<https://github.com/Manwar/Games-TicTacToe>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-tictactoe at rt.cpan.org>
or through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>.
I will  be notified & then you'll automatically be notified of progress on your bug
as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::TicTacToe::Move

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

1; # End of Games::TicTacToe::Move
