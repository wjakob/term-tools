#!/usr/bin/perl

# Password generator script.
#
# Passwords are generated from three pieces of information: the name of the
# entity for which a password is being generated (public), a passphrase known
# by the user (a relatively weak secret but not stored anywhere on the
# computer), and a file containing random data (a strong secret but one that
# might be compromised by an adversary who has taken over the machine).  It is
# fine--but not necessary--to reuse the same passphrase for all of your
# passwords.  Passwords can't be broken unless both of the two secrets are
# compromised or the adversary can crack MD5. Using a stronger hash function
# such as SHA-2 would be good, but the hash function is probably not the weak
# point in this scheme.
#
# Since the script takes several arguments, it may be convenient to create your
# own script or alias that invokes this one and passes the appropriate key-file
# as an argument. The accompanying script 'pw.release' can be used and
# customized to your own requirements.
#
# To create a key-file, I recommend the following command:
#
#   head -c 500 < /dev/random  >  <filename>
#
# Written by Andrew Myers, c. 2010. Version of Oct. 23, 2012.

use MIME::Base64;
use Digest::MD5 qw(md5_base64);
use strict;

my $shuffle = 1;
my $alpha = 0;
my $nopassphrase = 0;

while (1) {
    if ($ARGV[0] eq '-s') {
	$shuffle = !$shuffle;
	shift @ARGV;
    } elsif ($ARGV[0] eq '-a') {
	$alpha = 1;
	shift @ARGV;
    } elsif ($ARGV[0] eq '-p') {
	$nopassphrase = !$nopassphrase;
	shift @ARGV;
    } else {
	last;
    }
}

if ($#ARGV != 1) {
    print STDERR "Usage: make-password [-s] [-a] [-p] <identifier> <key-file|passphrase>\n";
    print STDERR "  where key-file should contain secret, unpredictable data.\n";
    print STDERR "  -s: toggle shuffling (on by default)\n";
    print STDERR "  -a: alphanumeric only\n";
    print STDERR "  -p: do not use passphrase (not recommended)\n";
    exit 1;
}

my $identifier = $ARGV[0];

my $keyfile = $ARGV[1];
my $bits, my $passphrase;

if (!open (KEYFILE, $keyfile)) {
    print STDERR "Cannot open $keyfile, instead using \"$keyfile\" as a passphrase.\r\n";
    $bits = '';
    $passphrase = $keyfile;
} else {
    if (!$nopassphrase) {
	print 'Passphrase: ';
	system('stty -echo');
	$passphrase = <STDIN>;
	system('stty echo'); print "\r\n";
	chomp $passphrase;
    }
    while (length($bits) < 20) {
        read KEYFILE, $bits, 20, length($bits)
    }
}

my $md5 = md5_base64($identifier, $passphrase, $bits);
my $md5_chars =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

my $prefix = substr($md5, 0, 5);

my $i6 = index $md5_chars, substr($md5, 5, 1);
my $i7 = index $md5_chars, substr($md5, 6, 1);
my $i8 = index $md5_chars, substr($md5, 7, 1);

my $punctuation = ".!#%&()*+,-./<=>?";
my $digits = "0123456789";
my $p6 = substr $punctuation, ($i6 % length $punctuation), 1;
my $p7 = substr $digits, ($i7 % 10), 1;
my $p8 = substr $digits, ($i8 % 10), 1;

my $unshuffled = $prefix . $p6 . $p7 . $p8;

if ($alpha) {
    my $alphanumeric = substr($md5_chars, 0, 62);
    $unshuffled = '';
    for (my $j = 0; $j < 8; $j++) {
	my $i = index $md5_chars, substr($md5, $j, 1);
	$unshuffled .= substr $alphanumeric, ($i % 62), 1;
    }
}

if ($shuffle) {
    my $shuffled;
    my $i9 = index $md5_chars, substr($md5, 8, 1);
    my $i10 = index $md5_chars, substr($md5, 9, 1);
    my $i11 = index $md5_chars, substr($md5, 10, 1);
    my $perm = ($i9 * 4096 + $i10*64 + $i11) % 40320;
    my @used;
    for (my $i = 8; $i >= 1; $i--) {
	my $j = $perm % $i; # -> use the jth unused index
	$perm /= $i;
	my $k;
	for ($k = 0; $j != 0 || $used[$k]; $k++) {
	    if (!$used[$k]) { $j--; }
	}
	$used[$k] = 1;
	$shuffled .= substr($unshuffled, $k, 1);
    }
    print $shuffled, "\r\n";
} else {
    print $unshuffled, "\r\n";
}
