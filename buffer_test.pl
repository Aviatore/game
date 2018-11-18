use strict;
use warnings;
use Term::Screen;
use Time::HiRes qw(usleep);
use Storable qw(dclone);
use lib ".";
use Line;

print "\e[?25l";
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
    elsif ( $yy == 0 )
    {
      $buffer[$yy][$xx] = "_";
    }
	elsif ( $yy == ($y - 1 ) )
    {
      $buffer[$yy][$xx] = "-";
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

my $line = Line->new(
	buffer => \@buffer, 
	row_num => $x, 
	col_num => $y
	);


#$line->add_line();
$line->add_pixel();

write_buffer(\$scr, \@buffer, \@buffer_2, $x, $y);
#exit;

my $counter = 0;
while(1)
{
	my $buffer_new = $line->move();
	if ( $counter == 1 )
	{
		$line->add_pixel();
		$counter = 0;
	}
	
	
	write_buffer_mod(\$scr, $buffer_new, \@buffer_2, $x, $y);

	$counter++;
	usleep(10000);
}

sub line_creator
{
	
}

# Firstly, pixel is removed, then the new one is printed (assuming right to left movement);
sub write_buffer_mod 
{
  my ( $scr, $buffer, $buffer_2, $x, $y ) = @_;

  for ( my $xx = $x - 1; $xx > 0; $xx-- )
  {
    for ( my $yy = $y - 1; $yy > 0; $yy-- )
    {
      if ( $$buffer[$yy][$xx] eq $$buffer_2[$yy][$xx] )
      {
		
        next;
      }
      else
      {
		print "\e[" . $yy . ";" . $xx . "H";
		print $$buffer[$yy][$xx];
        $$buffer_2[$yy][$xx] = $$buffer[$yy][$xx]; 
      }
#	  usleep(1000000);
    }
  }
}

# Firstly, new pixel is printed, then the old one is removed (assuming right to left movement);
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
#		$$scr->at( $yy, $xx );
		my $y = $yy;
		my $x = $xx;
		print "\e[" . $y . ";" . $x . "H";
		print $$buffer[$yy][$xx];
        $$buffer_2[$yy][$xx] = $$buffer[$yy][$xx]; 
      }
#	  usleep(10000);
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

