#!/usr/bin/perl
# psgrep
# Roy Prins, Innervate Services BV.

use strict;
use warnings;

my @fieldnames = qw(FLAGS UID PID PPID PRI NICE SIZE RSS WCHAN STAT TTY TIME COMMAND);

# determine the unpack format needed (hard-coded for Linux ps)
my $fmt = cut2fmt(8, 14, 20, 26, 30, 34, 41, 47, 59, 63, 67, 72);
my %fields;

die <<Message unless @ARGV;
   usage: $0 <field> ...
   Available fields:
   @fieldnames
Message

for my $name (@fieldnames) {
   no strict 'refs';
   *$name = *{lc $name} = sub () {
      $fields{$name}
   };
}

my $code = "sub is_desirable { " . join(" and ", @ARGV) . " } ";

unless (eval $code.1) {
   die "Error in code: $@\n\t$code\n";
}

open(PS, "ps wwaxl |") or die "cannot fork: $!";
<PS>;
while (<PS>) {
   @fields{@fieldnames} = trim(unpack($fmt, $_));
   print if is_desirable();
}

close(PS) || die "ps failed!";

sub cut2fmt {
   my(@positions) = @_;
   my $template = '';
   my $lastpos = 1;
   for my $place (@positions) {
      $template .= "A" . ($place - $lastpos) . " ";
      $lastpos = $place;
   }
   $template .= "A*";
   return $template;
}

sub trim {
   my @strings = @_;
   for (@strings) {
      s/^\s+//;
      s/\s+$//;
   }

   return wantarray ? @strings : $strings[0];
}
