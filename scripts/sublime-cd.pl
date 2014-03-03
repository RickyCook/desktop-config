#!/usr/bin/perl
use strict;
use warnings;

use File::Basename;

my $xwininfo = 'xwininfo -root -children|grep -Po \'".+?Sublime Text"\'|grep -o \'[^"].*[^"]\'';
open(
	my $info,
	"$xwininfo|"
) || die("Couldn't run: [$xwininfo]\n");

my $first = <$info>;
$first =~ s/ \([^)]+\) - Sublime Text 2//;
$first =~ s/~/$ENV{HOME}/; # this is really naive

print dirname($first);
