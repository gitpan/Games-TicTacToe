#!perl

use strict; use warnings;
use Games::TicTacToe;
use Test::More tests => 3;

my ($tictactoe);

eval { $tictactoe = Games::TicTacToe->new(current => 'm'); };
like($@, qr/isa check for "current" failed/);

eval { $tictactoe = Games::TicTacToe->new(board => undef); };
like($@, qr/isa check for "board" failed/);

eval { $tictactoe = Games::TicTacToe->new(players => undef); };
like($@, qr/isa check for "players" failed/);
