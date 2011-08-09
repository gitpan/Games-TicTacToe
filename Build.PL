use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    module_name       => 'Games::TicTacToe',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/Games/TicTacToe.pm',
    add_to_cleanup    => [ 'Games-TicTacToe-*' ],    
    build_requires    => {
        'Test::More'  => 0,
        'Test::Warn'  => 0,
        'Readonly'    => '1.03',
        'Mouse'       => '0.93',
    },
);

$builder->create_build_script();