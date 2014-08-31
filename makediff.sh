#make pdf diff using latexpand and latexdiff-fast
#preamble in diffpreamble.tex
#in diff, links are coloured green instead of blue
MAIN=$1
PATH=.:${PATH}
cur="$PWD"
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout 40ba29870a685004fc4d4458778bcd038f200524
#suppress diff of title
git cherry-pick 42ef1dd895681a9b387d2c624771f1784c42a3d8
#suppress diff of changelog
git cherry-pick 2cf864d5659977040fdbc7a60f5e0530611f71da
git cherry-pick 523d7d957f4cd93c8b58a24f6bb6a3b4d64d0b99
git cherry-pick de0a207286c4a53cc687e1c1a3409000d38be937
git cherry-pick a279f7f7fcce55a00c4e419114f5171912ab17ae


#mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
#sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
#wget http://www.ctan.org/pkg/latexpand
#chmod +x latexpand
latexpand $MAIN -o flat.tex
cd "${cur}"
git clone $PWD new
cd "${cur}/new"
#mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
#sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
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
latexdiff-fast --config \
"FLOATENV=(?:figure|longtable|table|tabular|plate)[\w\d*@]*" \
 --append-safecmd=field --append-textcmd=mmioreg --ignore-warnings -p diffpreamble.tex old/flat-fixed.tex new/flat-fixed.tex > virtio-diff.tex
#perl -pi fixupdiff.pl virtio-diff.tex
