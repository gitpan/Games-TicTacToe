#!perl

use strict; use warnings;
use Games::TicTacToe;

$SIG{'INT'} = sub { print {*STDOUT} "\n\nCaught Interrupt (^C), Aborting\n"; exit(1); };

my $response = 'Y';
while (defined($response)) {
    if ($response =~ /^Y$/i) {
        my $tictactoe = Games::TicTacToe->new;
        $tictactoe->addPlayer();
        my $index = 1;
        while (!$tictactoe->isGameOver()) {
            print {*STDOUT} $tictactoe->getGameBoard()
                if ($index %2 == 1);
            $tictactoe->play();
            $index++;
        }

        print {*STDOUT} "Do you wish to continue (Y/N)? ";
        $response = <STDIN>;
        chomp($response);
    }
    elsif ($response =~ /^N$/i) {
        print {*STDOUT} "Thank you.\n";
        last;
    }
    elsif ($response !~ /^[Y|N]$/i) {
        print {*STDOUT} "Invalid response, please enter (Y/N): ";
        $response = <STDIN>;
        chomp($response);
    }
}
