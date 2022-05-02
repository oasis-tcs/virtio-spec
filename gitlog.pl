#!/usr/bin/perl

#Usage: perl gitlog.pl [From..To]
#by default, logs from one before last version recorded in REVISION
use strict;

my $revs;
if ($#ARGV >= 0) {
	$revs = join(' ', @ARGV);
} else {
	# by default, get 1 revision before last
	my $rev = `git log -q --format=%h -n 1 --skip=1 REVISION`;
	chomp $rev;
	my $name=`git cat-file -p ${rev}:REVISION`;
	chomp $name;
	$name =~ s/^virtio-//;
	$revs = $name . "..";
}

print STDERR "LOG in the range $revs\n";

my @hashes=split(' ', `git log --reverse -q --format=%h ${revs}`);

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
