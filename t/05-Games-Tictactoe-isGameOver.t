#!perl

use strict; use warnings;
use Test::Warn;
use Games::TicTacToe;
use Test::More tests => 1;

my $tictactoe = Games::TicTacToe->new();

warning_is { eval { $tictactoe->isGameOver(); } } "WARNING: No player found to play the TicTacToe game.";