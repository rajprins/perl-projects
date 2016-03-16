#!/usr/bin/perl -w
use strict;

my $nr  = "156189148";
my $sum = 0;

(length($nr) == 9) ? print "Opgegeven nummer : $nr\n" : die "Fout: nummer $nr bestaat niet uit 9 cijfers!\n";
foreach (1..9) {
    $sum += substr($nr, -$_, 1) * $_;
}
(not ($sum % 11)) ? print "Voldoet aan elfproef : NEE\n" : print "Voldoet aan elfproef : JA\n";

