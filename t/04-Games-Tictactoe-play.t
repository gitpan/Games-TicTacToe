#!perl

use strict; use warnings;
use Games::TicTacToe;
use Test::More tests => 1;

my $tictactoe = Games::TicTacToe->new();

eval { $tictactoe->play(); };
like($@, qr/ERROR: Please add player before you start the game./);