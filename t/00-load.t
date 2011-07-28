#!perl

use Test::More tests => 4;

BEGIN 
{
    use_ok('Games::TicTacToe') || print "Bail out!";
    use_ok('Games::TicTacToe::Board') || print "Bail out!";
    use_ok('Games::TicTacToe::Player') || print "Bail out!";
    use_ok('Games::TicTacToe::Move') || print "Bail out!";
}