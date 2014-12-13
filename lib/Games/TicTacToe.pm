package Games::TicTacToe;

$Games::TicTacToe::VERSION = '0.06';

=head1 NAME

Games::TicTacToe - Interface to the TicTacToe (3x3) game.

=head1 VERSION

Version 0.06

=cut

use 5.006;
use Data::Dumper;
use Games::TicTacToe::Move;
use Games::TicTacToe::Board;
use Games::TicTacToe::Player;
use Games::TicTacToe::Params qw($Board $Player $Players);

use Moo;
use namespace::clean;

=head1 DESCRIPTION

A console  based TicTacToe game to  play against the computer. A simple TicTacToe
layer supplied with the distribution in the script sub folder.

=cut

$SIG{'INT'} = sub {
    print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1);
};

has 'board'   => (is => 'rw', isa => $Board,  default => sub { return Games::TicTacToe::Board->new; } );
has 'current' => (is => 'rw', isa => $Player, default => sub { return 'H'; });
has 'players' => (is => 'rw', isa => $Players);

=head1 METHODS

=head2 getGameBoard()

Returns game board for TicTacToe (3x3) as of now.

    use strict; use warnings;
    use Games::TicTacToe;

    my $tictactoe = Games::TicTacToe->new();
    print $tictactoe->getGameBoard();

=cut

sub getGameBoard {
    my ($self) = @_;

    return $self->{'board'}->as_string();
}

=head2 addPlayer()

Add player to the TicTacToe game. It prompts the  user to pick  the player  from
Human / Computer. As soon as the user picks one, it then asks to pick the symbol
for the selected user from X/O. Once  the player and symbol are selected then it
automatically selects the other player/symbol.

    use strict; use warnings;
    use Games::TicTacToe;

    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();

=cut

sub addPlayer {
    my $self = shift;

    if (defined($self->{players}) && (scalar(@{$self->{players}}) == 2)) {
        warn("WARNING: We already have 2 players to play the TicTacToe game.");
        return;
    }

    my ($type, $symbol);
    print {*STDOUT} "Please select the player [H - Human, C - Computer]: ";
    $type = <STDIN>;
    chomp($type) if defined $type;
    $type = _validate_player_type($type);
    print {*STDOUT} "Please select the symbol [X / O]: ";
    $symbol = <STDIN>;
    chomp($symbol);
    $symbol = _validate_player_symbol($symbol);

    # Player 1
    push @{$self->{players}}, Games::TicTacToe::Player->new(type => $type, symbol => $symbol);

    # Player 2
    $type   = ($type eq 'H')?('C'):('H');
    $symbol = ($symbol eq 'X')?('O'):('X');
    push @{$self->{players}}, Games::TicTacToe::Player->new(type => $type, symbol => $symbol);
}

=head2 getPlayers()

Returns the players information with their symbol.

    use strict; use warnings;
    use Games::TicTacToe;

    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();
    print $tictactoe->getPlayers();

=cut

sub getPlayers {
    my ($self) = @_;

    if (!defined($self->{players}) || scalar(@{$self->{players}}) == 0) {
        warn("WARNING: No player found to play the TicTacToe game.");
        return;
    }

    my $players = sprintf("+-------------+\n");
    foreach (@{$self->{players}}) {
        $players .= sprintf("|%9s: %s |\n", $_->desc, $_->symbol);
    }
    $players .= sprintf("+-------------+\n");

    return $players;
}

=head2 play()

Actually starts the game by prompty player to make a move.

    use strict; use warnings;
    use Games::TicTacToe;

    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();
    $tictactoe->play();

=cut

sub play {
    my ($self) = @_;

    die("ERROR: Please add player before you start the game.\n")
        unless (defined($self->{players}) && scalar(@{$self->{players}}) == 2);

    my $move = Games::TicTacToe::Move::now($self->_getCurrentPlayer, $self->board);
    $self->board->setCell($move, $self->_getCurrentPlayer->symbol);
    $self->_resetCurrentPlayer();
}

=head2 isGameOver()

Returns 1 or 0 depending whether the TicTacToe is over or not.It dumps the winner
name if any found. It also dumps the message if the games is drawn just in case.

    use strict; use warnings;
    use Games::TicTacToe;

    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();
    $tictactoe->play();
    print "Thank you!!!\n" if $tictactoe->isGameOver();

=cut

sub isGameOver {
    my ($self) = @_;

    if (!defined($self->{players}) || scalar(@{$self->{players}}) == 0) {
        warn("WARNING: No player found to play the TicTacToe game.");
        return;
    }

    foreach my $player (@{$self->{players}}) {
        if (Games::TicTacToe::Move::foundWinner($player, $self->board)) {
            print {*STDOUT} $self->getGameBoard();
            print {*STDOUT} $player->getMessage;
            return 1;
        }
    }

    if ($self->board->isFull()) {
        print {*STDOUT} $self->getGameBoard();
        print {*STDOUT} "Game drawn !!!\n";
        return 1;
    }

    return 0;
}

#
#
# PRIVATE METHODS

sub _validate_player_type {
    my ($player) = @_;

    while (defined($player) && ($player !~ /H|C/i)) {
        print {*STDOUT} "Please select a valid player [H - Human, C - Computer]: ";
        $player = <STDIN>;
        chomp($player);
    }

    return $player;
}

sub _validate_player_symbol {
    my ($symbol) = @_;

    while (defined($symbol) && ($symbol !~ /X|O/i)) {
        print {*STDOUT} "Please select a valid symbol [X / O]: ";
        $symbol = <STDIN>;
        chomp($symbol);
    }

    return $symbol;
}

sub _getCurrentPlayer {
    my ($self) = @_;

    ($self->{players}->[0]->{type} eq $self->{current})
    ?
    (return $self->{players}->[0])
    :
    (return $self->{players}->[1]);
}

sub _resetCurrentPlayer {
    my ($self) = @_;

    ($self->{players}->[0]->{type} eq $self->{current})
    ?
    ($self->{current} = $self->{players}->[1]->{type})
    :
    ($self->{current} = $self->{players}->[0]->{type});
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

    perldoc Games::TicTacToe

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

1; # End of Games::TicTacToe
