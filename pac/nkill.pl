#!/usr/bin/perl
# nkill.pl
# # Roy Prins, Innervate Services BV.

use strict;
use warnings;
use POSIX;

my $criminal = $ARGV[0];
my $user = getlogin() || getpwuid($<) ;
my $suspect;
my $pid = getpgrp( getpid() );

if ($criminal eq "") {
        print "Usage: pkill <processname>\n";
        exit 0;
}

open(DEATHROW, "ps -ef |"); # open 'ps' as input
while ($suspect = <DEATHROW>)
{
        chomp($suspect);
        $suspect =~ s/^\s+//;
        $suspect =~ s/\s+$//;
        my @suspect_chops = split /\s+/, $suspect,8;

        if ($suspect_chops[0] eq $user &&
            $suspect_chops[7] =~ $criminal &&      
            $suspect_chops[1] != $pid &&
            $suspect_chops[1] != getppid()-1 ) {
                system("kill -9 $suspect_chops[1] 2>> /dev/null" );
        }
}
close(DEATHROW);

exit 1;
