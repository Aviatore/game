package Line;

use strict;
use warnings;
use Data::Dumper;

sub new
{
	my $class = shift;
	my %options = @_;
	print join(":",@_);
	my $self = {
		%options
	};
	bless($self, $class);
	return $self;
}

sub add_line
{
	my $self = shift;
	my @line = ();
	
	
	for ( my $i = 2; $i < ($self->{col_num} - 1); $i++ )
	{
#		print $self->{col_num} - 1 . "\n";
	  push @line, [ ($i, $self->{row_num} - 2) ];
	}
	push @{$self->{lines}}, \@line;

}

sub add_pixel
{
	my $self = shift;
	
	my @pixel = ();
	my @acceptable_range =();
	
	for ( my $i = 2; $i < ($self->{col_num} - 1); $i++ )
	{
		push @acceptable_range, $i;
	}
	
	my $rand_index = int( rand( scalar(@acceptable_range) ) );
	push @pixel, [ ($acceptable_range[$rand_index], $self->{row_num} - 2) ];
	
	push @{$self->{lines}}, \@pixel;
}

sub move_mod
{
	my $self = shift;
	
	my $index = 0;
	foreach my $line ( @{$self->{lines}} )
	{
		$index = 0;
		foreach my $pixel ( @$line )
		{
			$self->{buffer}->[ $$line[$index]->[0] ][ $$line[$index]->[1] ] = " ";
			$$line[$index]->[1]--;
			$self->{buffer}->[ $$line[$index]->[0] ][ $$line[$index]->[1] ] = "#";
			$index++;
		}
	}
	return $self->{buffer};
}

sub move
{
	my $self = shift;
	
	my $index = 0;
	foreach my $line ( @{$self->{lines}} )
	{
		$index = 0;
		foreach my $pixel ( @$line )
		{
			$self->{buffer}->[ $$line[$index]->[0] ][ $$line[$index]->[1] ] = " ";
			$index++;
		}
	}
	
	foreach my $line ( @{$self->{lines}} )
	{
		$index = 0;
		foreach my $pixel ( @$line )
		{
			$$line[$index]->[1]--;
			$index++;
		}
	}
	
	foreach my $line ( @{$self->{lines}} )
	{
		$index = 0;
		foreach my $pixel ( @$line )
		{
			$self->{buffer}->[ $$line[$index]->[0] ][ $$line[$index]->[1] ] = "#";
			$index++;
		}
	}

	return $self->{buffer};
}

1;
