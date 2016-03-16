#!/usr/bin/perl

### Uses and Constants
use strict;
use warnings;
use Games::Sudoku::Component;



### Variables
my $sudoku;
my $file;
my $timestamp;

### Logic
sub intro {
    print "\n*******************************\n";
    print   "*   SUDOKU PUZZLE GENERATOR   *\n";
    print   "*******************************\n";
}


sub generate {
    print "- Generating Sudoku puzzle. This may take some time...";
    $sudoku = Games::Sudoku::Component->new(size => '9', );
    $sudoku->generate(blanks => '50', );
    print " done.\n";
}


sub show_puzzle {
    print "\n- Displaying puzzle:\n\n";
    print $sudoku->as_string(separator => ' ', linebreak => "\n", );
    print "\n";
}


sub save_puzzle {
    $timestamp = `date +"%Y%m%d"`;
    chomp $timestamp;
    $file = "sudoku-$timestamp".".html";
    print "\n- Saving puzzle as $file ...";
    open(OUT, "> $file") or die "Sorry, cannot save puzzle: $!\n";
    print OUT $sudoku->as_HTML;
    close(OUT);
    print " done.\n";
}

sub solve_puzzle {
    print "\n- Trying to solve the puzzle...";
    $sudoku->solve;
    print " done.\n";
}


sub check_solved {
    print "\n- Checking the result...";
    print $sudoku->is_solved ? " Solved!\n" : " Gave_up :-(\n";
}


sub show_solved {
    print "\n- Displaying solved puzzle:\n\n";
    print $sudoku->as_string(separator => ' ', linebreak => "\n", );
    print "\n";
}


sub save_solved {
    $timestamp = `date +"%Y%m%d"`;
    chomp $timestamp;
    $file = "solution-$timestamp".".html";
    print "\n- Saving solution as $file ...";
    open(OUT, "> $file") or die "Sorry, cannot save solution: $!\n";
    print OUT $sudoku->as_HTML;
    close(OUT);
    print " done.\n";
}


### Main
intro;
generate;
show_puzzle;
save_puzzle;
solve_puzzle;
check_solved;
show_solved;
save_solved;

