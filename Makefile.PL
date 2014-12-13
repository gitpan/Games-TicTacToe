use strict;use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Games::TicTacToe',
    AUTHOR             => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    VERSION_FROM       => 'lib/Games/TicTacToe.pm',
    ABSTRACT_FROM      => 'lib/Games/TicTacToe.pm',
    LICENSE            => 'artistic_2',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Warn' => 0,
    },
    PREREQ_PM => {
        'Moo'              => 0,
        'namespace::clean' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Games-TicTacToe-*' },
    (eval { ExtUtils::MakeMaker->VERSION(6.46) } ? (META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/Manwar/Games-TicTacToe.git',
                web  => 'https://github.com/Manwar/Games-TicTacToe',
            },
        }})
     : ()
    ),
);
