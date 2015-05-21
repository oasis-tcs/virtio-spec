my $bufferdiff="";
my $diff="";
my $buffer="";
while (<>) {
	my $line = $_;
	if (m/%DIFDELCMD\s+<\s+\\begin{lstlisting}/) {
		$lstlisting=1;
		$line =~s/%DIFDELCMD\s+</{\\lstset{escapechar=\\\$} /;
	}
	if ($lstlisting) {
		$line =~ s/%DIFDELCMD\s+< //;
		if (not $line =~ m/\\(?:begin|end){lstlisting}/) {
			$line =~ s/([#&{} ])/\\$1/g;
			$line =~ s/(.*)/\$\\DIFdel{$1}\$/;
		}
		#print "%FIXED BY RULE 1\n";
	}
	#In section headings, replace begin/end with begin/endFL,
	#but be careful in case some tag spills over to the next
	#line
	if (m/\\(section|subsection|subsubsection|paragraph)/ and m/DIF/) {
		my @list = split(/(\\DIF(?:add|del)(?:begin|end)(?:FL)?)/, $line, -1);
		#if there's only one tag, don't touch it:
		#matching one is on the other line
		if ($#list >= 5) {
			#if first tag is end, don't touch it - matching
			#begin is on the previous line
			if ($list[1] =~ m/begin$/) {
				$list[1] .= "FL";
			}
			#if last tag is begin, don't touch it - matching
			#end is on the next line
			if ($list[$#list - 1] =~ m/end$/) {
				$list[$#list - 1] .= "FL";
			}
		}
		for (my $i = 3; $i <= $#list - 3; $i += 2) {
			if (not $list[$i] =~ m/FL$/) {
				$list[$i] .= "FL";
			}
		}
		$line = join("", @list);
		#print "%FIXED BY RULE 2\n";
	}
	#detect where we have DIFbegin/end cross
	#enumerate/itemize environments and fix up
	if (m/\\DIF(?:add|del)(?:begin|end)/) {
		my @list = split(/(\\DIF(?:add|del)(?:begin|end)(?:FL)?)/, $line, -1);
		$diff = $list[$#list - 1];
		if ($diff =~ m/begin/) {
			$diff =~ s/begin/end/;
		} else {
			$diff = "";
		}
	}
	if ($diff ne "" and m/\\(?:begin|end){(?:enumerate|itemize)}$/ and not m/\\DIF/) {
		$buffer = $line;
		$bufferdiff = $diff;
		$line = "";
		#print "%BUFFERED BY RULE 3: $bufferdiff\n";
	}
	if ($buffer ne "" and $line ne "") {
		if (m/^(\\DIF(?:add|del)end(?:FL)?)/ and $bufferdiff ne $1) {
			$line =~ s/^(\\DIF(?:add|del)end(?:FL)?)//;
			$buffer =~ s/(\\(?:begin|end){(?:enumerate|itemize)})$/$bufferdiff$1/;
			#print "%FIXED BY RULE 3: $bufferdiff\n";
		}
		print $buffer;
		$buffer = "";
		$bufferdiff = "";
	}
	print $line;
	if (m/%DIFDELCMD\s+<\s+\\end{lstlisting}/) {
		print "}\n";
		$lstlisting=0;
	}
}
