package Games::TicTacToe::Move;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Games::TicTacToe::Move - Interface to the TicTacToe game's move.

=head1 VERSION

Version 0.05

=cut

$SIG{'INT'} = sub { print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1); };

our $VERSION = '0.05';
Readonly my $BEST_MOVE    => [4, 0, 2, 6, 8];
Readonly my $WINNING_MOVE => [ [0, 1, 2],
                               [0, 3, 6],
                               [0, 4, 8],
                               [1, 4, 7],
                               [2, 5, 8],
                               [2, 4, 6],
                               [3, 4, 5],
                               [6, 7, 8],
                             ];

=head1 DESCRIPTION

The module used by the parent module Games::TicTacToe.

=head1 METHODS

=head2 foundWinner()

Return 1 or 0 depending wether we have a winner or not.

=cut

sub foundWinner
{
    my $player = shift;
    my $board  = shift;
    croak("ERROR: Player not defined.\n") unless defined $player;
    croak("ERROR: Board not defined.\n")  unless defined $board;
    
    foreach (@$WINNING_MOVE)
    {
        return 1 if $board->_belongsToPlayer($_, $player);
    }
    return 0;
}

=head2 now()

Make a move now for the current player.

=cut

sub now
{
    my $player = shift;
    my $board  = shift;
    croak("ERROR: Player not defined.\n") unless defined $player;
    croak("ERROR: Board not defined.\n")  unless defined $board;
    
    if ($player->type eq 'H')
    {
        return _humanMove($board);
    }
    else
    {
        return _computerMove($board, $player);
    }
}

sub _humanMove
{
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    return _validate_human_move($board);
}

sub _computerMove
{
    my $board  = shift;
    my $player = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    my $move = _getBestMove($board, $player);
    return $move unless ($move == -1);
    
    foreach (@$BEST_MOVE) 
    {
        return $_ if $board->_isCellEmpty($_);
    }

    foreach (0..8)
    {
        return $_ if $board->_isCellEmpty($_);
    }
}

sub _getBestMove
{
    my $board  = shift;
    my $player = shift;

    my $move = _isWinningMove($board, $player->symbol);
    return $move unless ($move == -1);
    return _isWinningMove($board, $player->otherSymbol());
}

sub _isWinningMove
{
    my $board  = shift;
    my $symbol = shift;
    
    foreach (@{$WINNING_MOVE})
    {
        return $_->[0]
            if ($board->_isCellEmpty($_->[0]) && $board->_cellContains($_->[1], $symbol) && $board->_cellContains($_->[2], $symbol));
        return $_->[1]
            if ($board->_isCellEmpty($_->[1]) && $board->_cellContains($_->[0], $symbol) && $board->_cellContains($_->[2], $symbol));
        return $_->[2]
            if ($board->_isCellEmpty($_->[2]) && $board->_cellContains($_->[0], $symbol) && $board->_cellContains($_->[1], $symbol));
    }
    return -1;
}

sub _validate_human_move
{
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    print {*STDOUT} "What is your next move [".$board->_availableIndex()."]? ";
    my $move = <STDIN>;
    chomp($move);
    return _validate_move($move, $board);
}

sub _validate_move
{
    my $move  = shift;
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    while (!(defined($move) && ($move >= 1) && ($move <= 9) && ($board->_isCellEmpty($move-1))))
    {
        print {*STDOUT} "Please make a valid move [".$board->_availableIndex()."]: ";
        $move = <STDIN>;
        chomp($move);
    }
    return ($move-1);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-tictactoe at rt.cpan.org> or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>. I will 
be notified & then you'll automatically be notified of progress on your bug as I make changes.

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

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of Games::TicTacToe::Move