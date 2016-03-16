#!/usr/bin/perl

use strict;
use warnings;

my $target="LetterBingo.txt";
my @selectie = qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z Ä Ö Ü SZ);
my $line = qq(---------------------\n);

print "Hoeveel LetterBingo kaarten zal ik aanmaken? ";
my $kaarten = <STDIN>;
chomp $kaarten;

open(FH, "> $target") or die "Kan bestand $target niet aanmaken. Foutmelding: $!\n";

print FH "* * * B I N G O * * *\n";

for (my $i=1; $i <= $kaarten; $i++) {
   print FH "\nKaart $i\n";
   print FH $line;
   
   for (my $y=1; $y <= 25; $y++) {
      my $letter = $selectie[int rand @selectie];
      if (($y%5 == 0) && ($letter eq "SZ")) {
         print FH "| $letter|\n";
         print FH $line;
      }
      elsif (($y%5 == 0) && ($letter ne "SZ")) {
         print FH "| $letter |\n";
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

close(FH); 

print "\nEr zijn $kaarten bingo kaarten gemaakt in bestand $target \n" ;
