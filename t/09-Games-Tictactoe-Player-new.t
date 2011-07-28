#!perl

use strict; use warnings;
use Games::TicTacToe::Player;
use Test::More tests => 2;

eval { Games::TicTacToe::Player->new(type => 'Q'); };
like($@, qr/Attribute \(type\) does not pass the type constraint/);

eval { Games::TicTacToe::Player->new(symbol => 'R'); };
like($@, qr/Attribute \(symbol\) does not pass the type constraint/);