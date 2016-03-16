#!/usr/bin/perl
# ProcessTree.pl
# Roy Prins, Innervate Services BV.

use strict;

my @leader = '`-';
my %kids;
my %data;
my $init = 1;

local $" = ',';
open PS, "-|", "ps -e -o pid,ppid,comm " or die "Cannot execute ps: $!\n";

sub showproc ($;$) {
   my $pid = shift;
   my $vert = shift || '  ' ;
   
   print @leader, "$pid $data{$pid}\n";
   next unless exists $kids{$pid};
   
   $leader[-1] = '| ';
   push @leader, '`-';
   
   my @kids = sort { $a <=> $b } @{$kids{$pid}};
   foreach (@kids) {
      $leader[-1] = $_ == $kids[-1] ? '`-' : '+-';
      $leader[-2] = $vert;
      showproc($_, $_ == $kids[-1] ? '  ' : '| ');
   }
   pop @leader;
}

<PS>;
while (<PS>) {
   chomp;
   my ($pid, $ppid, $state, $data) = split " ", $_, 4;
   if ($state eq 'Z') {
      $data = '<zombie>';
   }

   if ($pid == $ppid) {
      $init = $pid;
   } else {
      push @{$kids{$ppid}}, $pid;
   }
}
close PS;

showproc $init;     
