use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Games::TicTacToe',
    AUTHOR        => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM  => 'lib/Games/TicTacToe.pm',
    ABSTRACT_FROM => 'lib/Games/TicTacToe.pm',
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean         => { FILES => 'Games-TicTacToe-*' },
    PREREQ_PM     => {
        'Test::More' => 0,
        'Test::Warn' => 0,
        'Readonly'   => 0,
        'Mouse'      => '0.93',
    },
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
);