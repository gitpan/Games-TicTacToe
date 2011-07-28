package Games::TicTacToe;

use Mouse;
use Mouse::Util::TypeConstraints;

use Carp;
use Data::Dumper;

use Games::TicTacToe::Move;
use Games::TicTacToe::Board;
use Games::TicTacToe::Player;

=head1 NAME

Games::TicTacToe - Interface to the TicTacToe game.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

A console based TicTacToe game to play against the computer.A simple TicTacToe player supplied
with the distribution in the script sub folder.

=cut

$SIG{'INT'} = sub { print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1); };

has  'board'   => (is => 'rw', isa => 'Games::TicTacToe::Board', default => sub { return Games::TicTacToe::Board->new(); } );
has  'players' => (is => 'rw', isa => 'ArrayRef[Games::TicTacToe::Player]');
has  'current' => (is => 'rw', isa => 'Player', default => 'H');

=head1 METHODS

=head2 getGameBoard()

Returns game board for TicTacToe (3x3) as of now.

    use strict; use warnings;
    use Games::TicTacToe;
    
    my $tictactoe = Games::TicTacToe->new();
    print $tictactoe->getGameBoard();

=cut

sub getGameBoard
{
    my $self = shift;
    return $self->{'board'}->as_string();
}

=head2 addPlayer()

Add player to the TicTacToe game.It prompts the user to pick the player from Human / Computer.
As soon as the user picks one, it then asks to pick the symbol for the selected user from X/O.
Once the player and symbol are selected then it automatically selects the other player/symbol.

    use strict; use warnings;
    use Games::TicTacToe;
    
    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();

=cut

sub addPlayer
{
    my $self = shift;
    
    if (defined($self->{players}) && (scalar(@{$self->{players}}) == 2))
    {
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

sub getPlayers
{
    my $self = shift;
    if (!defined($self->{players}) || scalar(@{$self->{players}}) == 0)
    {
        warn("WARNING: No player found to play the TicTacToe game.");
        return;
    }
    
    my $players = sprintf("+-------------+\n");
    foreach (@{$self->{players}})
    {
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

sub play
{
    my $self = shift;
    croak("ERROR: Please add player before you start the game.\n")
        unless (defined($self->{players}) && scalar(@{$self->{players}}) == 2);

    my $move = Games::TicTacToe::Move::now($self->_getCurrentPlayer, $self->board);
    $self->board->setCellIndex($move, $self->_getCurrentPlayer->symbol);
    $self->_resetCurrentPlayer();
}

=head2 isGameOver()

Returns 1 or 0 depending whether the TicTacToe is over or not. It dumps the winner name if any 
found. It also dumps the message if the games is drawn just in case.

    use strict; use warnings;
    use Games::TicTacToe;
    
    my $tictactoe = Games::TicTacToe->new();
    $tictactoe->addPlayer();
    $tictactoe->play();
    print "Thank you!!!\n" if $tictactoe->isGameOver();

=cut

sub isGameOver
{
    my $self = shift;
    if (!defined($self->{players}) || scalar(@{$self->{players}}) == 0)
    {
        warn("WARNING: No player found to play the TicTacToe game.");
        return;
    }
    
    foreach my $player (@{$self->{players}})
    {
        if (Games::TicTacToe::Move::foundWinner($player, $self->board))
        {
            print {*STDOUT} $player->getMessage;
            return 1;
        }    
    }
    if ($self->board->isFull())
    {
        print {*STDOUT} "Game drawn!!!\n";
        return 1;
    }
    
    return 0;
}

sub _validate_player_type
{
    my $player = shift;

    while (defined($player) && ($player !~ /H|C/i))
    {
        print {*STDOUT} "Please select a valid player [H - Human, C - Computer]: ";
        $player = <STDIN>;
        chomp($player);
    }
    return $player;
}

sub _validate_player_symbol
{
    my $symbol = shift;
    while (defined($symbol) && ($symbol !~ /X|O/i))
    {
        print {*STDOUT} "Please select a valid symbol [X / O]: ";
        $symbol = <STDIN>;
        chomp($symbol);
    }
    return $symbol;
}

sub _getCurrentPlayer
{
    my $self = shift;

    if ($self->{players}->[0]->{type} eq $self->{current})
    {
        return $self->{players}->[0];
    }
    else
    {
        return $self->{players}->[1];
    }
}

sub _resetCurrentPlayer
{
    my $self = shift;
    if ($self->{players}->[0]->{type} eq $self->{current})
    {
        $self->{current} = $self->{players}->[1]->{type};
    }
    else
    {
        $self->{current} = $self->{players}->[0]->{type};
    }
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-tictactoe at rt.cpan.org> or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>. I will 
be notified & then you'll automatically be notified of progress on your bug as I make changes.

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

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Mouse; # Keywords are removed from the Games::TicTacToe package
no Mouse::Util::TypeConstraints;

1; # End of Games::TicTacToe