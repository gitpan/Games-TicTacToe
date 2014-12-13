#!perl

use strict; use warnings;
use Games::TicTacToe::Board;
use Test::More tests => 1;

my $board = Games::TicTacToe::Board->new();

is($board->isFull(), 0);