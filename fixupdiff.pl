my $lstlisting=0;
while (<>) {
	my $line = $_;
	if (m/%DIFDELCMD\s+<\s+\\begin{lstlisting}/) {
		$lstlisting=1;
	}
	if ($lstlisting) {
		$line =~ s/%DIFDELCMD\s+<\s+//;
	}
	print $line;
	if (m/%DIFDELCMD\s+<\s+\\end{lstlisting}/) {
		$lstlisting=0;
	}
}
