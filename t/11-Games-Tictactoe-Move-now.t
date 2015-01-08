﻿#!perl

use strict; use warnings;
use Games::TicTacToe;
use Games::TicTacToe::Move;
use Games::TicTacToe::Player;
use Test::More tests => 2;

my $player1 = Games::TicTacToe::Player->new(type => 'H', symbol => 'X');
my $player2 = Games::TicTacToe::Player->new(type => 'C', symbol => 'O');
my $tictactoe = Games::TicTacToe->new(players => [$player1, $player2]);

eval { Games::TicTacToe::Move::now(); };
like($@, qr/ERROR: Player not defined/);

eval { Games::TicTacToe::Move::now($tictactoe->players); };
like($@, qr/ERROR: Board not defined/);