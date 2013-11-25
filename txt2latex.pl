#!/usr/bin/perl

use strict;

my @depth2latex = (
	'\chapter',
	'\section',
	'\subsection',
	'\subsubsection',
	'\paragraph',
	'\subparagraph'
);

my $skip_depth = 1;

sub find_footnotes {
	my @text = @_;
	my @notes = ();
	my $found = 0;
	my $l;

	for ($l = 0; $l <= $#text; $l++) {
		if ($text[$l] =~ m/^FOOTNOTES:$/) {
			$found = 1;
		}
		next unless $found;
		if ($text[$l] =~ m/^\[[0-9]+\]\s/) {
			push @notes, $l;
		}
	}
	return @notes;
};

sub find_sections {
	my @text = @_;
	my @sections = ();
	my $l;

	for ($l = 0; $l <= $#text - 1; $l++) {
		next unless (($text[$l + 1] =~ m/^=======*$/) or
			     ($text[$l + 1] =~ m/^-------*$/));

		next unless ($text[$l] =~ m/^(([0-9]+\.)+) /);

		push @sections, $l;

	}
	return @sections;
};

my @text = ();
while (<>) {
	push @text, $_;
}

my @footnotes = find_footnotes(@text);
my @sections = find_sections(@text);

#Format footnotes
my %footnote_by_number = ();
my $f;
for ($f = 0; $f <= $#footnotes; $f++) {
	my $l = $footnotes[$f];
	die unless ($text[$l] =~ m/^\[([0-9]+)\]\s+(.*)/);
	my $footnote = $1;
	my $text = $2;
	die "duplicate footnote number $footnote" if defined($footnote_by_number{$footnote});
	$footnote_by_number{$footnote} = "$text\n";
	my $next;
	if ($f < $#footnotes) {
		$next = $footnotes[$f + 1];
	} else {
		$next = $#text + 1;
	}
	for ($l = $footnotes[$f] + 1; $l < $next; $l++) {
		next if ($text[$l] =~ m/^$/);
		$footnote_by_number{$footnote} .= $text[$l];
	}
}

#Format sections
my %label_by_section = ();
my $s;

my %latest_by_depth = ();

for ($s = 0; $s <= $#sections; $s++) {
	my $l = $sections[$s];
	die unless ($text[$l] =~ m/^(([0-9]+\.)+)\s+(.+)\s*/);
	my $section = $1;
	my $name = $3;
 	my @path = split(/\./, $section);
	my $depth = $#path - $skip_depth;
	if ($depth < 0) {
		$depth = 0;
	}
	if ($depth > $#depth2latex) {
		$depth = $#depth2latex;
	}
	$latest_by_depth{$#path} = $name;
 	my $type = $depth2latex[$depth];
	my $label = $name;
	#Prepend hierarchical path to make name unique
	for (my $i = 1; $i <= $#path - $skip_depth; $i++) {
		last if (not defined $latest_by_depth{$#path - $i});
		$label = "$latest_by_depth{$#path - $i} / $label";
	}
	$text[$l] = $type . "{$name}\\label{sec:$label}\n";
	$label_by_section{$section} = $label;
}

my $ifndef = 0;
my $listing = 0;
my $table = 0;
my $buffer = "";
for my $line (@text) {
	last if ($line =~ m/^FOOTNOTES:$/);
	next if (($line =~ m/^=======*$/) or
		 ($line =~ m/^-------*$/));

	if ($line =~ m/^#if/) {
		print "\\begin{lstlisting}\n";
		$ifndef++;
	}
	if ($ifndef) {
		if ($line =~ m/^#endif/) {
			$ifndef--;
		}
		$buffer .= $line;
		if (not $ifndef) {
			print $buffer;
			print "\\end{lstlisting}\n";
			$buffer = "";
		}
		next;
	}
	if (not $table and $line =~ m/^\+\-/) {
		print "\\begin{verbatim}\n";
		$table = 1;
	}
	if ($table and not $line =~ m/^(\+\-|\|)/) {
		print "\\end{verbatim}\n";
		$table = 0;
	}
	if (not $listing and $line =~ m/^\t/) {
		print "\\begin{lstlisting}\n";
		$listing = 1;
	}
	if ($listing and $line =~ m/^$/) {
		$buffer .= $line;
		next;
	}
	if ($listing and not $line =~ m/^\t/) {
		print "\\end{lstlisting}\n";
		$listing = 0;
	}

	if (not $table and not $listing) {
		if ($line =~ m/\S+\s*\^\s*\S+/) {
			$line =~ s/(\S+\s*\^\s*)(\S+)/\$$1\{$2\}\$/g;
		} else {
			$line =~ s/\^/\\^/go;
		}
		$line =~ s/#/\\#/go;
		$line =~ s/&/\\&/go;
		if ($line =~ m/\[[0-9]+\]/) { #premature optimization
			for my $n (keys(%footnote_by_number)) {
				my $txt = $footnote_by_number{$n};
				$line =~ s/\[$n\]/\n\\footnote{$txt}/g;
			}
		}
	}
	if ($line =~ m/"(([0-9]+\.)+)[^"]*"/) {
		my $section = $1;
		$line =~ s/"(([0-9]+\.)+)[^"]*"/\\ref{sec:$label_by_section{$section}}~\\nameref{sec:$label_by_section{$section}}/g;
	}
	print $buffer;
	$buffer = "";
	print $line;
}


