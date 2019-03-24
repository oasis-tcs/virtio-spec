#!/usr/bin/perl

use strict;

my @hashes=split(' ', `git log --reverse -q --format=%h virtio-v1.1-csprd01..`);

sub escapelatex {
	my $s = shift;
	$s =~ s/[\\]/\\textbackslash /go;
	$s =~ s/([&#%{}\$])/\\$1/go;
	$s =~ s/[~]/\\~{}/go;
	$s =~ s/(https?:\S*)/\\url{$1}/go;
#1st line always on a separate paragraph
	$s =~ s/\n/\n\n/o;
#Guess where new paragraph starts
	$s =~ s/\\.\n/.\n\n/go;
	$s =~ s/\n-/\n\n-/go;
	return $s;
}

for my $h (@hashes) {
	my $date = `git show -q --format='%cd' --date='format:%d %b %Y' $h`;
	chomp $date;
	my $author = `git show -q --format='%aN' $h`;
	chomp $author;
	my $cl = `git show -q --format='%B' $h`;
	$cl = escapelatex($cl);
	print "$h & $date & $author & { $cl } \\\\\n";
	print "\\hline\n";
}
