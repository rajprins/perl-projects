#!/usr/bin/perl
# ShowProcs.pl
# Roy Prins, Innervate Services BV.

use strict;
use warnings;

my %childs;
open PS, "-|", "ps -e -o pid,ppid,comm " or die "Cannot execute ps: $!\n";

<PS>;
while (<PS>) {
        chomp;
        my ($pid, $ppid, $comm) = split " ", $_, 3;
        push @{$childs{$ppid}}, $pid;
}
close PS;

foreach my $parent (sort {$a <=> $b} keys %childs) {
        my @childs = sort {$a <=> $b} @{$childs{$parent}};

        print "Process $parent has ", 
              scalar @{$childs{$parent}}, 
              @{$childs{$parent}}==1 ? " child: " : " children: ",
              join(", ", @{$childs{$parent}}), "\n";
}

