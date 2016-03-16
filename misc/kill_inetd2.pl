#!/usr/bin/perl -w

use strict;
use Proc::ProcessTable;
use Tk;
   
   
sub kill_them {
	$t = new Proc::ProcessTable;  
	foreach $p (@{$t->table}) {
		kill $signal, $p->pid if $p->cmndline =~ $keyword;
	}
	$result_text = "Signal $signal sent to all '$keyword' processes.";
}


$main = MainWindow->new();

$main->Label(-text =>  "Control panel for killing processes\n   enter keyword here")->pack();
$main->Entry(-textvariable => \$keyword)->pack();
$radiobutton_frame = $main->Frame->pack();
$radiobutton_frame->Radiobutton(-text => "KILL",
   -variable => \$signal,
   -value => 9)->pack(-side => left);
$radiobutton_frame->Radiobutton(-text => "TERM",
   -variable => \$signal,
   -value => 15)->pack(-side => left);
$main->Button(-text => "Send kill signal to named processes",
  -command => \&kill_them)->pack();
$main->Label(-textvariable => \$result_text)->pack();

# Set reasonable defaults.
$keyword = "inetd";
$signal = 9;

MainLoop();
