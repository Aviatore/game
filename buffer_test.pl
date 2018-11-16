use strict;
use warnings;
use Term::Screen;
use Time::HiRes qw(usleep);
use Storable qw(dclone);

$| = 1;
my @buffer = ();
my $scr = new Term::Screen;
$scr->clrscr();
my $x = $scr->cols();
my $y = $scr->rows();
my @used = ();
for ( my $xx = 0; $xx < $x; $xx++ )
{
  for ( my $yy = 0; $yy < $y; $yy++ )
  {
    my $coord = $xx . ":" . $yy;
    push @used, $coord;
  }
}

intro(\$scr,\@used,$x,$y);

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

