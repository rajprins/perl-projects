#!/usr/bin/perl
# ShowAllUsers.pl
# Roy Prins, Innervate Services BV.

use strict;
use warnings;

my @userdata;
my $teller = 0;

unless (-r "/etc/passwd") { 
   die "Cannot open password file: $!\n";
}

open PW, "< /etc/passwd";

while (<PW>) {
   $teller++;
   chomp ;
   @userdata = split /\:/, $_;

   if ($userdata[6] eq "/sbin/nologin") {
      print "[$teller] $userdata[0] (user ID: $userdata[2], *NOLOGIN*)\n";
   } else {
      print "[$teller] $userdata[0] (user ID: $userdata[2])\n";
   }
}

