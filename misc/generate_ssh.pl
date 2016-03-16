#!/usr/bin/perl
#
# To set up ssh keys 
#

# set up "global" vars
$home = $ENV{"HOME"};
$remotemachine = $ARGV[0];
$user = $ENV{"USER"};

# see if keys exist
if (-e !"/$home/.ssh/id_dsa.pub") {
    `ssh-keygen -t dsa`
};

`scp /$home/.ssh/id_dsa.pub $remotemachine://home/$user/.ssh/authorize
+d_keys2`;
`ssh-agent sh -c 'ssh-add < /dev/null && bash'`;
`ssh $remotemachine`;
exit (0);