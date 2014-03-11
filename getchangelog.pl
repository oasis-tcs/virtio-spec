#!/usr/bin/perl

use strict;

my $rev = undef;
if ($#ARGV >= 0) {
	$rev = shift @ARGV;
} else {
	open(REV, "git svn log REVISION|") || die;
	while (<REV>) {
		next unless (m/^(r[0-9]+)/);
		#top revision is WD, skip it
		if (not defined $rev) {
			$rev = $1;
			next;
		} else {
			$rev = $1;
			last;
		}
	}
}

die unless $rev =~ m/^r([0-9]+)$/;
$rev = $1;

sub escapelatex {
	my $s = shift;
	$s =~ s/[\\]/\\textbackslash /go;
	$s =~ s/([&#%{}\$])/\\$1/go;
	$s =~ s/[~]/\\~{}/go;
	$s =~ s/(https?:\S*)/\\url{$1}/go;
	return $s;
}

#map editors to authors
my %editors = {};
$editors{'rusty'} = 'Rusty Russell <rusty@au1.ibm.com>';
$editors{'hornet'} = 'Pawel Moll <pawel.moll@arm.com>';
$editors{'cornelia.huck'} = 'Cornelia Huck <cornelia.huck@de.ibm.com>';
$editors{'mstsirkin'} = 'Michael S. Tsirkin <mst@redhat.com>';

my $cl = "";
my $signoff = undef;
my $editor = undef;
my $date = undef;
my $r = undef;
open(LOG, "git svn log *tex|") || die;
my $line = undef;
while (<LOG>) {
	if (m/^------------------------------------------------------------------------$/) {
		next if ($cl eq "");
		# act on it
		my $author;
		if (defined $signoff) {
			$author = $signoff;
		} else {
			$author = $editors{$editor};
		}
		#strip mail info
		$author =~ s/\s*<.*//;
		$cl = escapelatex($cl);
		print "$r & $date & $author & { $cl } \\\\\n";
		print "\\hline\n";

		$cl = "";
		$signoff = undef;
		$editor = undef;
		$date = undef;
		$r = undef;

		$line = 0;
		next;
	}
	$line++;
#r164 | mstsirkin | 2013-12-08 14:30:55 +0200 (Sun, 08 Dec 2013)| 6 lines

	if ($line eq 1) {
		die unless (m/^r[0-9]/);
		my @rinfo = split(/\s*\Q|\E\s*/, $_);
		$r = $rinfo[0];

		die unless $r =~ m/^r([0-9]+)$/;
		$r = $1;
		last if ($r <= $rev);

		$editor = $rinfo[1];
		$date = $rinfo[2];
		die unless ($date =~ m/^[^(]*\([^,]*,\s*([^)]+)\)\s*$/);
		$date = $1;
		next;
	}
	next if (m/^$/);

	# First signature is the author: needed?
	# ignore for now
	#if (not defined $signoff and m/^Signed-off-by:\s*(.*)/) {
	#	$signoff = $1;
	#}
	# skip signatures
	next if (m/^\s*[A-Z][A-Za-z-]*-by:/);


	# fix bug: wrong date in some commit logs
	if (/Change accepted on VIRTIO TC Meeting, 3 December 2013/) {
		$_ = "Change accepted on Virtio TC Meeting Minutes: Feb 25, 2014\n";
	}

	$cl .= $_;
}
