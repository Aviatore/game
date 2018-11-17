use strict;
use warnings;
use Term::Screen;
use Time::HiRes qw(usleep);
use Storable qw(dclone);

$| = 1;
my @buffer = ();
my @buffer_2 = ();
my $scr = new Term::Screen;
$scr->clrscr();
my $x = $scr->cols();
my $y = $scr->rows();
my @used = ();
for ( my $xx = 0; $xx < $x; $xx++ )
{
  for ( my $yy = 0; $yy < $y; $yy++ )
  {
    if ( ( $xx == 0 or $xx == ($x - 1) ) and $yy > 0 )
    {
      $buffer[$yy][$xx] = "|";
    }
    elsif ( $yy == 0 or $yy == ($y - 1 ) )
    {
      $buffer[$yy][$xx] = "_";
    }
    else
    {
      $buffer[$yy][$xx] = " ";
    }
    $buffer_2[$yy][$xx] = " ";

    my $coord = $xx . ":" . $yy;
    push @used, $coord;
  }
}

my @line = ();
for ( my $i = 1; $i < ($y - 2); $i++ )
{
  push @line, [ ($i, $x - 2) ];
}
 write_buffer(\$scr, \@buffer, \@buffer_2, $x, $y);
 exit;


while(1)
{
  my $index = 0;

  foreach my $pixel ( @line )
  {
    $buffer[ $line[$index]->[0] ][ $line[$index]->[1] ] = " ";
    $index++;
  }

  foreach my $pixel ( @line )
  {
    $line[$index]->[1]--;
    $index++;
  }

  foreach my $pixel ( @line )
  {
    $buffer[ $line[$index]->[0] ][ $line[$index]->[1] ] = "#";
    $index++;
  }

  write_buffer(\$scr, \@buffer, \@buffer_2, $x, $y);

  sleep 1;
}

sub write_buffer
{
  my ( $scr, $buffer, $buffer_2, $x, $y ) = @_;

  for ( my $xx = 0; $xx < $x; $xx++ )
  {
    for ( my $yy = 0; $yy < $y; $yy++ )
    {
      if ( $$buffer[$yy][$xx] eq $$buffer_2[$yy][$xx] )
      {
        next;
      }
      else
      {
        $$scr->at( $yy, $xx );
        print $buffer[$yy][$xx];

        $$buffer_2[$yy][$xx] = $$buffer[$yy][$xx]; 
      }
    }
  }
}

#intro(\$scr,\@used,$x,$y);

sub intro
{
  my $scr = $_[0];
  my $used = $_[1];
  my @used_tmp = @$used;

  intro_print("#", \@used_tmp, $scr);
  intro_print(" ", \@used_tmp, $scr);
}

sub intro_print
{
  my $string = $_[0];
  my $buffer = $_[1];
  my $buffer_tmp = dclone $buffer;
  my $scr = $_[2]; 
  while ( scalar( @$buffer_tmp ) > 0 )
  {
      my $rand_index = int( rand( scalar(@$buffer_tmp) ) );
      my ($x, $y) = split( ":", $$buffer_tmp[$rand_index] );
      $$scr->at( $y, $x );
      print $string;
      splice(@$buffer_tmp, $rand_index, 1);
     
      usleep(500);
  }
}

