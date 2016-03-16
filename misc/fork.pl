#!/usr/bin/perl 
#
# A fork() demo. This program will sit in the background and
# make a list of the process which uses the maximum CPU average
# at 1 minute intervals. On a quiet BSD like system this will
# normally be the swapper (long term scheduler).
#

use strict;
use warnings;

my $true = 1;
my $logfile="perl.cpu.logfile";

print "Max CPU logfile, forking daemon...\n";

if (fork()) {
   exit(0);
} 

while ($true) {
   open (logfile,">> $logfile") or die "Can't open $logfile\n";
   open (ps,"/usr/bin/ps aux |") or die "Couldn't open a pipe from ps !!\n";

   $skip_first_line = <ps>;
   $max_process = <ps>;
   close(ps);

   print logfile $max_process;
   close(logfile);
   sleep 60;

   ($a,$b,$c,$d,$e,$f,$g,$size) = stat($logfile);

   if ($size > 500) {
      print STDERR "Log file getting big, better quit!\n";
      exit(0);
   }
}
