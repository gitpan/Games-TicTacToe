#!perl

use strict; use warnings;
use Games::TicTacToe;

$SIG{'INT'} = sub { print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1); };

my ($response);
do
{
    print {*STDOUT} "Do you wish to play tic tac toe (Y/N)? ";
    $response = <STDIN>;
    if (defined $response)
    {
        chomp($response) ;
        print {*STDOUT} "Invalid response, please enter (Y/N).\n"    
            unless ($response =~ /Y|N/i);

        if ($response =~ /Y/i)
        {
            my $tictactoe = Games::TicTacToe->new();
            $tictactoe->addPlayer();
            while (!$tictactoe->isGameOver())
            {
                print {*STDOUT} $tictactoe->getGameBoard();
                $tictactoe->play();
            }
            print {*STDOUT} $tictactoe->getGameBoard();
        }
    }    
} while (!defined($response) || ($response !~ /Y|N/i));

print {*STDOUT} "Thank you.\n";