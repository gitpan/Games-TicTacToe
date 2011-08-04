package Games::TicTacToe::Board;

use Mouse;
use Mouse::Util::TypeConstraints;

use Carp;
use Readonly;
use Data::Dumper;

=head1 NAME

Games::TicTacToe::Board - Interface to the TicTacToe game's board.

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';
Readonly my $EMPTY => '\d';

=head1 DESCRIPTION

The module used by the parent module Games::TicTacToe.

=cut

has 'cell' => (is => 'rw', isa => 'ArrayRef[Str]', default => sub { return ['1','2','3','4','5','6','7','8','9']; });

=head1 METHODS

=head2 isFull()

Return 1 or 0 depending whether the game board is full or not.

=cut

sub isFull
{
    my $self = shift;
    foreach (0..8)
    {
        return 0 if $self->_isCellEmpty($_);
    }
    return 1;
}

=head2 setCell()

Set the cell with the player symbol.

=cut

sub setCell
{
    my $self   = shift;
    my $index  = shift;
    my $symbol = shift;
    croak("ERROR: Missing cell index for TicTacToe Board.\n") unless defined $index;
    croak("ERROR: Missing symbol for TicTacToe Board.\n") unless defined $symbol;
    croak("ERROR: Invalid cell index value for TicTacToe Board.\n") unless ($index =~ /^[1-9]$/);
    croak("ERROR: Invalid symbol for TicTacToe Board.\n") unless ($symbol =~ /^[X|O]$/i);
    
    $self->{cell}->[$index-1] = $symbol;
}

=head2 getCell()

Get the cell symbol in the given index.

=cut

sub getCell
{
    my $self  = shift;
    my $index = shift;
    croak("ERROR: Missing cell index for TicTacToe Board.\n")
        unless defined($index);
    croak("ERROR: Invalid index value for TicTacToe Board.\n")
        unless (($index >= 0) && ($index <= 8));

    return $self->{cell}->[$index];
}

=head2 as_string()

Returns the current game board.

=cut

sub as_string
{
    my $self  = shift;
    my $board = sprintf("+-----------+\n");
    $board .= sprintf("| TicTacToe |\n");
    $board .= sprintf("+---+---+---+\n");
    foreach my $row (1..3)
    {
        foreach my $col (1..3)
        {
            $board .= sprintf("| %s ", $self->_getCellRowCol($row, $col));
        }
        $board .= sprintf("|\n+---+---+---+\n");
    }
    return $board;
}

sub _getCellRowCol
{
    my $self = shift;
    my $row  = shift;
    my $col  = shift;
    croak("ERROR: Missing row/col value for TicTacToe Board.\n")
        unless (defined($row) && defined($col));
    croak("ERROR: Invalid value for row/col for TicTacToe Board.\n")
        unless (($row >= 1) && ($row <= 3) && ($col >= 1) && ($col <= 3));

    my $index = ($row == 1)?(0):(($row == 2)?(3):(6));
    return $self->getCell(($index+$col)-1);
}

sub _isCellEmpty
{
    my $self  = shift;
    my $index = shift;
    
    return 1 if ($self->getCell($index) =~ /$EMPTY/);
    return 0;
}

sub _availableIndex
{
    my $self  = shift;
    my $index = '';
    
    foreach (1..9)
    {
        $index .= $_ . "," if $self->_isCellEmpty($_-1);
    }
    $index =~ s/\,$//g;
    return $index;
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-games-tictactoe at rt.cpan.org> or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Games-TicTacToe>. I will 
be notified & then you'll automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Games::TicTacToe::Board

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Games-TicTacToe>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Games-TicTacToe>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Games-TicTacToe>

=item * Search CPAN

L<http://search.cpan.org/dist/Games-TicTacToe/>

=back

=head1 LICENSE AND COPYRIGHT

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Mouse; # Keywords are removed from the Games::TicTacToe::Board package
no Mouse::Util::TypeConstraints;

1; # End of Games::TicTacToe::Board