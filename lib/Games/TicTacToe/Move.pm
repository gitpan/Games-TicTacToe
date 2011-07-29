package Games::TicTacToe::Move;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Games::TicTacToe::Move - Interface to the TicTacToe game's move.

=head1 VERSION

Version 0.02

=cut

$SIG{'INT'} = sub { print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1); };

our $VERSION = '0.02';
Readonly my $BEST_MOVE    => [5, 1, 3, 7, 9];
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
        return 1
            if (($board->getCell($_->[0]) eq $player->symbol)
                && 
                ($board->getCell($_->[1]) eq $player->symbol)
                &&
                ($board->getCell($_->[2]) eq $player->symbol));
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
        return _computerMove($board);
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
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    foreach (@$BEST_MOVE) 
    {
        return $_ if ($board->getCell($_-1) eq ' ');
    }

    foreach (1..9)
    {
        return $_ if ($board->getCell($_-1) eq ' ');
    }
}

sub _validate_human_move
{
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    print {*STDOUT} "What is your next move [1-9]? ";
    my $move = <STDIN>;
    chomp($move);
    return _validate_move($move, $board);
}

sub _validate_move
{
    my $move  = shift;
    my $board = shift;
    croak("ERROR: Board not defined.\n") unless defined $board;
    
    while (!(defined($move) && ($move >= 1) && ($move <= 9) && ($board->getCell($move-1) eq ' ')))
    {
        print {*STDOUT} "Please make a valid move [1-9]: ";
        $move = <STDIN>;
        chomp($move);
    }
    return $move;
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