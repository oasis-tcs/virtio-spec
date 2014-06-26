#make pdf diff using latexpand and latexdiff-fast
#preamble in diffpreamble.tex
#in diff, links are coloured green instead of blue
MAIN=$1
PATH=.:${PATH}
cur="$PWD"
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout ec1ffbf27a8f0a06ca65cd498a69c7f89bd97dc1
mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
#wget http://www.ctan.org/pkg/latexpand
#chmod +x latexpand
latexpand $MAIN -o flat.tex
cd "${cur}"
git clone $PWD new
cd "${cur}/new"
mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
latexpand $MAIN -o flat.tex
cd "${cur}"
# latexdiff does not do diffs within footnotes
# adding space make it not realize the text is a footnote,
# and treat it normally
sed 's/\\footnote{/\\footnote {/' old/flat.tex > old/flat-fixed.tex
sed 's/\\footnote{/\\footnote {/' new/flat.tex > new/flat-fixed.tex
#cp old/flat.tex old/flat-fixed.tex
#cp new/flat.tex new/flat-fixed.tex
#wget http://mirror.math.ku.edu/tex-archive/support/latexdiff/latexdiff-fast
#chmod +x latexdiff-fast
latexdiff-fast --config "FLOATENV=(?:figure|table|tabular|plate)[\w\d*@]*" --append-safecmd=field --ignore-warnings -p diffpreamble.tex old/flat-fixed.tex new/flat-fixed.tex > virtio-diff.tex
#perl -pi fixupdiff.pl virtio-diff.tex
