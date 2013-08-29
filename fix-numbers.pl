#!/usr/bin/perl

use strict;

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

sub get_section {
	my ($section, @prevpath) = @_;
	my @path = split(/\./, $section);

	#Possible cases:
	if ($#path > $#prevpath) {
#		Path deeper than parent: just add .1
		my $diff = $#path - $#prevpath;
		@path = @prevpath;
		for (my $i = 0; $i < $diff; $i++) {
			push @path, 1;
		}
	} elsif ($#path == $#prevpath) {
#		Same level as parent
		@path = @prevpath;
		$path[$#path]++;
	} elsif ($#path < $#prevpath) {
#		Higher level than parent
		@path = @prevpath[0 .. $#path];
		$path[$#path]++;
	}
	my $newsection = join('.', @path) . '.';
	my $prev = join('.', @prevpath) . '.';
	return ($newsection, @path);
};

my @text = ();
while (<>) {
	push @text, $_;
}

my @footnotes = find_footnotes(@text);
my @sections = find_sections(@text);

#Set new numbers for footnotes
my %footnote_by_old_reference = ();
my $f;
for ($f = 0; $f <= $#footnotes; $f++) {
	my $l = $footnotes[$f];
	die unless ($text[$l] =~ m/^\[([0-9]+)\]\s/);
	my $footnote = $1;
	my $newfootnote = $f + 1;
	die "duplicate footnote number $footnote" if defined($footnote_by_old_reference{$footnote});
	$footnote_by_old_reference{$footnote} = $newfootnote;
}

#Find and fix references to footnotes
my $l;
for ($l = 0; $l <= $#text; $l++) {
	next unless $text[$l] =~ m/\[[0-9]+\]/; #premature optimization
	for my $old (keys(%footnote_by_old_reference)) {
		my $new = $footnote_by_old_reference{$old};
		next if $new eq $old;
		$text[$l] =~ s/\[$old\]/[XYX$new]/g;
	}
	$text[$l] =~ s/\[XYX/[/go;
}

#Set new numbers for sections
my %section_by_old_reference = ();
my $s;
my @path = ();

for ($s = 0; $s <= $#sections; $s++) {
	my $l = $sections[$s];
	die unless ($text[$l] =~ m/^(([0-9]+\.)+)/);
	my $section = $1;
	my ($newsection, @p) = get_section($section, @path);
	@path = @p;
	die "duplicate section number $section" if defined($section_by_old_reference{$section});
	$section_by_old_reference{$section} = $newsection;
}

#Find and fix references to sections
my $l;
for ($l = 0; $l <= $#text; $l++) {
	next unless $text[$l] =~ m/^(([0-9]+\.)+)/; #premature optimization
	for my $old (keys(%section_by_old_reference)) {
		my $new = $section_by_old_reference{$old};
		next if $new eq $old;
		
		my @p = split(/\./, $old);
		my $pattern = join("\\.", @p) . "\\.";
		my @s = split(/\./, $new);
		my $subst = join("XYX", @s) . "XYX";
		$text[$l] =~ s/$pattern/$subst/g;
	}
	$text[$l] =~ s/XYX/./go;
}


for my $line (@text) {
	print $line;
}


