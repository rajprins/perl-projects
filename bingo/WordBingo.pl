#!/usr/bin/perl

use strict;
use warnings;

my $target="kaarten.doc";
my @selectie = qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z Ä Ö Ü SZ);
my $line = qq(---------------------\\par\n);

print "Hoeveel Bingo kaarten zal ik aanmaken? ";
my $kaarten = <STDIN>;
chomp $kaarten;

open(FH, "> $target") or die "Kan bestand $target niet aanmaken. Foutmelding: $!\n";
open(IN, "< header.txt") or die "Fout bij aanmaken Word bestand: $!\n";

while (<IN>) {
   print FH $_ ;
   print "\n";
   shift;
}
close(IN);

for (my $i=1; $i <= $kaarten; $i++) {

   if (($i > 1) and ($i % 2 != 0)) { print FH qq(\\page); }

   print FH "\\par Kaart $i\\par\n";
   print FH $line;
   
   for (my $y=1; $y <= 25; $y++) {
      my $letter = $selectie[int rand @selectie];
      if (($y%5 == 0) && ($letter eq "SZ")) {
         print FH "| $letter|\\par\n";
         print FH $line;
      }
      elsif (($y%5 == 0) && ($letter ne "SZ")) {
         print FH "| $letter |\\par\n";
         print FH $line;
      }
      elsif (($y%5 != 0) && ($letter eq "SZ")) {
         print FH "| $letter";
      }
      elsif (($y%5 != 0) && ($letter ne "SZ")) {
         print FH "| $letter ";
      } 
   }
}

print FH qq(}});
close(FH); 

print "Er zijn $kaarten bingo kaarten gemaakt in bestand $target \n" ;
