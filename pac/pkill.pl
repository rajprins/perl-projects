#!/usr/bin/perl
# pkill.pl
# Roy Prins, Innervate Services BV.

use strict;
use warnings;
use POSIX;

my $tagged;
my $user = getlogin() || getpwuid($<) ;
my $suspect;
my $pid = getpgrp(getpid());

if ($ARGV[0] ne "") {
   $tagged = $ARGV[0];   
} else {
   print "Usage: pkill <processname>\n";
   exit 0;
}

open(PROCLIST, "ps -ef |") or die "Cannot get process list!";
while ($suspect = <PROCLIST>) {
   chomp($suspect);
   $suspect =~ s/^\s+//;
   $suspect =~ s/\s+$//;
   my @suspect_chops = split /\s+/, $suspect,8;

   if ($suspect_chops[0] eq $user &&
       $suspect_chops[7] =~ $tagged &&      
       $suspect_chops[1] != $pid &&
       $suspect_chops[1] != getppid()-1 )
   {
      system("kill -9 $suspect_chops[1] 2>> /dev/null" );
   }
}
close(PROCLIST);

exit 1;
