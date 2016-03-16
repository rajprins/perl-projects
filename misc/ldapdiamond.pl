#!/usr/local/bin/perl -w
BEGIN {
	use CGI;
	CGI->import(qw(:standard));
	require CGI::Carp;
	CGI::Carp->import('fatalsToBrowser');
        use Net::LDAP;
}

print header;
print start_html(-title=>"DIAMOND LDAP logon", 
                 -meta=>{"GENERATOR" => "LDAP logon",
                         "AUTHOR"    => "Carry Megens"},
		         -style=>{'src'=>'http://pww.comres.philips.com/css/style.css'},  
                 -class=>'p-popup',
                 -bgcolor=>'white',),"\n";
#
# if no parameters or only parameter user given 
# show form asking password fields
#

if (!param() || (param('user') && !param('pwd')))
{
  $user       = param("user");
  print qq~
  <h1>DIAMOND LDAP logon</h1>
  <form action=$ENV{SCRIPT_NAME} method=post>
  <table width="600" border="0" class="p-mf">
  <tr><th align=left width=100>Name</th><td><input type=text name=user size=20 value="$user"></td>
  <tr><th align=left width=100>Password</th><td><input type=password name=pwd size=8 maxsize=8></td>
  <tr><th align=left colspan=2><input type=submit value='Login'></th></tr>
  </table>
  </form>
  ~;
}
else # handle form parameters
{
    $user       = param("user");
    $pwd        = param("pwd");

$LDAPserver = "ehvrds01.diamond.philips.com";
$LDAPport = 389;
$LDAPbase = "ou=SC,o=Philips";
$AttributeList = "Mail telephonenumber location";

$ldap = Net::LDAP->new("$LDAPserver", port=> $LDAPport) or die("Unable connect $LDAPserver");
#
# Authenticated bind 
#
$mesg = $ldap->bind(dn => $user, password => $pwd);
if ($mesg->code == 0) {
	#
	# Authenticated, perform a search
	#
	$mesg = $ldap->search(	base => $LDAPbase,
			filter => "(|(cn=$user)(sn=$user))");
	if ($mesg->code) 
	{
  		print $mesg->error;
  		exit;
	}
	#
	# What info to display
	#
	@Attributes = split(/ /, $AttributeList);
	#
	# get list of all entries
	#
	@entries = $mesg->entries;
	#
	# cycle through all entries
	#
	$NoFound = @entries;
	if($#entries > -1)
	{
		print "<h1>$user logged on</h1>";
		print "<table width=640 cellpadding=1 cellspacing=0 border=0 bgcolor=darkblue><tr><td>";
		print "<table width=640 cellpadding=3 cellspacing=0 border=0 bgcolor=white>";
		print "<tr bgcolor=#dddddd valign=top><td><b>Name</b><br><font size=-2></font></td>";
		foreach $attribute (@Attributes)
		{
   			print "<td bgcolor=#eeeeee><b>$attribute</b></td>";
		}
		print "</tr><tr bgcolor=#efefef></tr>";
		foreach $entry (@entries)
		{
			$name = $entry->get("cn");
			$Name = @{$name}[0];
   			print "<tr><td bgcolor=#eeeeee>$Name</td>";
			foreach $attribute (@Attributes)
			{
				$mail = $entry->get("$attribute");
				$Mail = "@{$mail}";
				&urlify($Mail);
				print "<td><FONT COLOR=blue>$Mail</FONT></td>" if $Mail;
				print "<td>no info available</td>" if !$Mail;
			}
			print "</tr><tr bgcolor=#efefef></tr>";
		}
	    print "</td></tr></table></table>";
	}
	else {chop($user);print "<P>No entries found for \"$user\".";}
	$ldap->unbind;
}
else {    		print $mesg->error; }
}


sub urlify
{
#by tchrist@perl.com
   require 5.002;  # well, or 5.000 if you see below

   my $urls = '(' . join ('|', qw{
                 http
                 telnet
                 gopher
                 file
                 wais
                 mailto
                 ftp
             } )
         . ')';

   my $ltrs = '\w';
   my $gunk = '/#~:.?+=&%@!\-';
   my $punc = '.:?\-';
   my $any  = "${ltrs}${gunk}${punc}";

   (map {

## use this if early-ish perl5 (pre 5.002)
##  s{\b(${urls}:[$any]+?)(?=[$punc]*[^$any]|\Z)}{<A HREF="$1">$1</A>}goi;
## otherwise use this -- it just has 5.002ish comments
       s{
         \b                          # start at word boundary
         (                           # begin $1  {
           $urls     :               # need resource and a colon
           [$any] +?                 # followed by on or more
                                     #  of any valid character, but
                                     #  be conservative and take only
                                     #  what you need to....
         )                           # end   $1  }
         (?=                         # look-ahead non-consumptive assertion
                 [$punc]*            # either 0 or more puntuation
                 [^$any]             #   followed by a non-url char
             |                       # or else
                 $                   #   then end of the string
         )
       }{<A HREF="$1">$1</A>}igox
      
       or
      
       s{
      	\b
      	(
      		[$any]+\@[$any]+?
      	)
          (?=                         # look-ahead non-consumptive assertion
                 [$punc]*            # either 0 or more puntuation
                 [^$any]             #   followed by a non-url char
             |                       # or else
                 $                   #   then end of the string
          )
       }{<a href="mailto:$1">$1</a>}igox
       ;
      
   $_ } @_ )

}