#!/usr/bin/perl

use strict;
use warnings;

my $infile; 
my $outfile;
my $effe;
my @results;

(defined $ARGV[0]) ? chomp($infile = $ARGV[0]) : chomp($infile = 'sql.txt');
(defined $ARGV[1]) ? chomp($outfile = $ARGV[1]) : chomp($outfile = 'statements.txt');

open(IN, "< $infile") or die "Kan inputbestand $infile niet openen: $!\n";
open(OUT, "> $outfile") or die "Kan outputbestand $outfile niet openen: $!\n";

while (<IN>) {
   s/--.*//;
   s/\t/\ /g;
   s/\n/\ \n/;
   s/\ \ +/\ /g;
   s/insert/INSERT/imgsox; 
   s/update/UPDATE/imgsox; 
   s/delete/DELETE/imgsox;
   chomp($effe .= $_);
}
close(IN);

$effe =~ s/\ \ /\ /gsx;
@results = split(/\;/, $effe);

foreach (@results) {
   $_ .= "\;\n";
   if ((/^INSERT+\s/i) || (/\sINSERT+\s/i)) {
      print OUT substr $_, index($_, 'INSERT');
   } 
	elsif ((/^UPDATE+\s/i) || (/\sUPDATE+\s/i)) {
      print OUT substr $_, index($_, 'UPDATE');
   } 
	elsif ((/^DELETE+\s/i)  || (/\sDELETE+\s/i)) {
      print OUT substr $_, index($_, 'DELETE');
   }
}

close(OUT);

print "All done.\n";