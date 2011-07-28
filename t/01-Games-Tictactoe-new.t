#!perl

use strict; use warnings;
use Games::TicTacToe;
use Test::More tests => 3;

my ($tictactoe);

eval { $tictactoe = Games::TicTacToe->new(current => 'm'); };
like($@, qr/Attribute \(current\) does not pass the type constraint/);

eval { $tictactoe = Games::TicTacToe->new(board => undef); };
like($@, qr/Attribute \(board\) does not pass the type constraint/);

eval { $tictactoe = Games::TicTacToe->new(players => undef); };
like($@, qr/Attribute \(players\) does not pass the type constraint/);