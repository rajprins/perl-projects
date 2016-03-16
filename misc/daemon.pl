#!C:\perl\bin\perl.exe -w

use strict;
use warnings;
use IO::File;

my $timeout = 10;

sub startdaemon {
   my ($pid) = fork();
   if ($pid) {
      defined $pid or die "Cannot fork: $!\n";
   } 
   else {
      my $logfile = "log.".`date +"%Y%m%d"`;
      my $filehandle = IO::File->new;
      $filehandle->open("> $logfile") or die "Cannot create logfile: $!\n";
      $filehandle->autoflush(1) ;
      open STDIN, '/dev/null' or die "Cannot read /dev/null: $!";
      open STDOUT, ">&", $filehandle or die "Cannot write to $logfile: $!";
#      open STDERR, ">&", STDOUT or die "Cannot redirect to STDOUT: $!\n";

      open F, "ping nlassv33|" or die "Cannot fork: $!";
      while (<F>) {
         if ($_ =~ /icmp_seq=7/) {
            print $filehandle "   -> encountered 7th echo request!\n" ;
         }else{
	 	print $filehandle "Got it:$_\n";
	 }
      }
   }
}


### main 

$SIG{ALRM} = sub {
   die "timeout"
};

eval {
   alarm($timeout);
   startdaemon();
   while(1){}
   alarm(0);
};

if ($@) { #eval value
   if ($@ =~ /timeout/) { #we're timed oud...
      print "Exiting parent...";   
   }
   else {
      alarm(0);	#end timeout
      die;	#bye bye
   }
}
