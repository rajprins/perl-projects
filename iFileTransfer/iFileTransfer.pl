#! /usr/bin/perl

use strict;
use warnings;
use Tk;
use File::Copy;
use Net::FTP;
# Uncomment the following two lines if this program is going to run
# under MS Windows.
use Tk::Scale;
use File::DosGlob 'glob';


my $UserID;
my $Password;
my @Local_Files;
my @Remote_Files;
my $Local_Total_Files;
my $Remote_Total_Files = 0;
my $Status_msg = "Innervate File Transfer Tool";
my $Main_Dir = "d:/transfer";
my $Local_Dir = "d:/transfer";
my $Remote_Dir = "/opt/shared";
my $Archive_Dir = "opt/shared/archive";
my $Remote_IP_Address = "80.112.194.116";
my $Xfer_Progress = 0;


#####################################################################
# Window variables													#
#####################################################################
my $mw;
my $frmUserID;
my $lblUserID;
my $frmPassword;
my $lblPassword;
my $edtUserID;
my $edtPassword;
my $frmTop;
my $frmBig;
my $frmButtonLine;
my $btnTransmit;
my $btnExit;
my $frmFilesLabels;
my $lblLocalFiles;
my $lblRemoteFiles;
my $frmFiles;
my $lstLocalFiles;
my $lstRemoteFiles;
my $frmFileTotals;
my $lblLocalTotalLabel;
my $lblLocalTotalFiles;
my $lblRemoteTotalFiles;
my $lblRemoteTotalLabel;
my $lblStatus;
my $sclProgress;
my $lblZeroPercent;
my $lblOneHundredPercent;


init_mainwindow();
MainLoop;



sub init_mainwindow {
	$mw = MainWindow->new;
	$mw->title("Innervate File Transfer");
	$mw->resizable(0, 0);
	#$mw->minsize qw(600 600);
	$mw->geometry("+300+100");
	
	# Top Level frame for top section of form.
	$frmTop = $mw->Frame(-bd => 2, -relief => 'ridge')
		->pack(-side => 'top', -fill => 'x', -pady => 3);


	$frmUserID = $frmTop->Frame(-bd => 2)->pack(-side => 'top', -fill => 'x');
	$lblUserID = $frmUserID->Label(-text => "User ID:")->pack(-side => 'left');
	$edtUserID = $frmUserID->Entry(-textvariable => \$UserID, -background => 'white')->pack(-side => 'left');

	$frmPassword = $frmTop->Frame(-bd => 2)->pack(-side => 'top', -fill => 'x');
	$lblPassword = $frmPassword->Label(-text => "Password:")->pack(-side => 'left');
	$edtPassword = $frmPassword->Entry(-textvariable => \$Password, -background => 'white', -show => "*")
		->pack(-side => 'left');

	# Top Level frame for middle section of form.
	$frmBig = $mw->Frame(-bd => 2, -relief => 'ridge')->pack(-side => 'top', -fill => 'x');


	$frmFilesLabels = $frmBig->Frame(-bd => 2)->pack(-side => 'top', -fill => 'x', -padx => 5);
	$lblLocalFiles = $frmFilesLabels->Label(-text => "Local Files")->pack(-side => 'left');
	$lblRemoteFiles = $frmFilesLabels->Label(-text => "Remote Files")->pack(-side => 'right');

	$frmFiles = $frmBig->Frame(-bd => 2)->pack(-side => 'top', -fill => 'x', -padx => 2);
	$lstLocalFiles = $frmFiles->Scrolled("Listbox"
					     ,-takefocus => 0
					     ,-scrollbars => "e"
					     , -background => 'white'
					     , -width => 22)->pack(-side => 'left', -padx => 5);
	$lstRemoteFiles = $frmFiles->Scrolled("Listbox"
					      , -takefocus => 0
					      ,-scrollbars => "e"
					      , -background => 'white'
					      , -width => 22)->pack(-side => 'right', -padx => 5);

	$frmFileTotals = $frmBig->Frame(-bd => 2)->pack(-side => 'top', -fill => 'x', -padx => 5, -pady => 5);
	$lblLocalTotalLabel = $frmFileTotals->Label(-text => "Total Files:")
		->pack(-side => 'left');
	$lblLocalTotalFiles = $frmFileTotals->Label(-textvariable =>
		\$Local_Total_Files, -relief => 'sunken', -background => 'white',
		-width => 5)->pack(-side => 'left');
	$lblRemoteTotalFiles = $frmFileTotals->Label(-textvariable =>
		\$Remote_Total_Files, -relief => 'sunken', -background => 'white',
		-width => 5)->pack(-side => 'right');
	$lblRemoteTotalLabel = $frmFileTotals->Label(-text => "Total Files:")
		->pack(-side => 'right');

	# Top Level frame for bottom section of form.
	$frmButtonLine = $mw->Frame(-bd => 2, -relief => 'ridge')
		->pack(-side => 'top', -fill => 'x', -pady => 3);
	$btnExit = $frmButtonLine->Button(-text => "Exit", 
		-command => \&close_mw, -width => 6)->pack(
		-side => 'right', -padx => 1);
	$btnTransmit = $frmButtonLine->Button(-text => "Transmit",
		-command => \&transmit_files, -width => 6)->pack(
		-side => 'right', -padx => 1);
	$lblZeroPercent = $frmButtonLine->Label(-text => '0%')
		->pack(-side => 'left', -anchor => 's');
	$sclProgress = $frmButtonLine->Scale(-from => 0, -to => 100,
		-orient => 'horizontal',
		-label => 'Transfer Progress',
		-sliderlength => 10, -variable => \$Xfer_Progress,
		-length => 150, -showvalue => 0, -state => 'disabled')
		->pack(-side => 'left');
	$lblOneHundredPercent = $frmButtonLine->Label(-text => '100%')
		->pack(-side => 'left', -anchor => 's');


	$lblStatus = $mw->Label(-textvariable => \$Status_msg,
		-borderwidth => 1, -relief => 'groove')
		->pack(-fill => 'x', -side => 'bottom');

	fill_local_listbox();
	$edtUserID->focus;
	
}


sub transmit_files {
	my $file;
	my $ftp;
	my $files_transmitted = 0;
	my $files_archived = 0;
	my $total_size = 0;
	my $files_transmitted_size = 0;
			
	update_status("");
	$Xfer_Progress = 0;
	$sclProgress -> update;
	
	unless (defined($UserID)) {
		update_status("Must enter a user id!");
		$edtUserID->focus;
		return 0;
	}
	unless (defined($Password)) {
		update_status("Must enter a password!");
		$edtPassword->focus;
		return 0;
	}
	update_status("Logging into remote host...");
	$ftp = Net::FTP->new($Remote_IP_Address);
	unless ($ftp->login($UserID, $Password)) {
		update_status("Could not log in to remote host!");
		$edtUserID->focus;
		return 0;
	}
	update_status("Changing to remote directory...");
	unless ($ftp->cwd("/opt/shared")) {
		update_status("Could not go to remote directory!");
		$edtUserID->focus;
		return 0;
	}
	
	while ($file = <$Local_Dir/*>) {
		$total_size += (-s $file);
	}
	
	while ($file = <$Local_Dir/*>) {
		$files_transmitted_size += (-s $file);
		$file =~ s#.*/##;
		update_status("Copying $file...");
		if (defined($ftp->put("$Local_Dir/$file", $file))) {
			$lstRemoteFiles->insert('end', $file);
			$Remote_Total_Files++;
			$files_transmitted++;
			$Xfer_Progress = ($files_transmitted_size / $total_size) * 100;
			$sclProgress -> update;
			if (archive_file($file)) {
				$files_archived++;
			}
		}
	}
	$ftp->quit;
	fill_local_listbox();
	update_status("$files_transmitted file(s) were transmitted. " . 
		"$files_archived files(s) were archived.");
}
	

sub archive_file {
	my ($file) = @_;
	my $file_count = 0;
	
	if (-e "$Archive_Dir/$file") {
		unlink("$Archive_Dir/$file");
	}
	if (move("$Local_Dir/$file", "$Archive_Dir")) {
		return 1;
	}
	else {
		return 0;
	}
}


sub fill_local_listbox {
	my $next_name;

	$lstLocalFiles->delete(0, 'end');
	$Local_Total_Files = 0;	
	while ($next_name = <$Local_Dir/*>) {
		$next_name =~ s#.*/##;
		$lstLocalFiles->insert('end', $next_name);
		$Local_Total_Files++;
	}
}


sub close_mw {
	$mw->destroy;
}


sub update_status {
	my ($msg) = @_;
	
	$Status_msg = $msg;
	$lblStatus -> update;
}