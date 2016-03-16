#!/usr/bin/perl
use POSIX;
use strict;
use warnings;

# Elements of current time:
# - Seconds past the minute
# - Minutes past the hour
# - Hours past midnight
# - Day of the month
# - Months past the start of the year
# - Number of years since 1900
# - Number of days since the start of the week (Sunday)
# - Number of days since the start of the year
# - Whether or not daylight savings is active 



my $sec  =  6;
my $min  =  7;
my $hour =  8;
my $day  =  9;
my $mon  = 10   - 1;
my $year = 2004 - 1900;
my $wday = 0;
my $yday = 0;

my $unixtime = mktime ($sec, $min, $hour, $day, $mon, $year, $wday, $yday);
print "Unixtime: $unixtime\n";

my $readable_time = localtime($unixtime);
print "Time: $readable_time\n";
