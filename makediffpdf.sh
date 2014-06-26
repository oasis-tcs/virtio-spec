#make pdf diff using latexpand and latexdiff-fast
#preamble in diffpreamble.tex
#in diff, links are coloured green instead of blue
PATH=.:${PATH}
cur="$PWD"
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout ec1ffbf27a8f0a06ca65cd498a69c7f89bd97dc1
mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
sed s/blue/green/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
#wget http://www.ctan.org/pkg/latexpand
#chmod +x latexpand
latexpand virtio.tex -o flat.tex
cd "${cur}"
git clone $PWD new
cd "${cur}/new"
mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
sed s/blue/green/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
latexpand virtio.tex -o flat.tex
cd "${cur}"
#wget http://mirror.math.ku.edu/tex-archive/support/latexdiff/latexdiff-fast
#chmod +x latexdiff-fast
latexdiff-fast -p diffpreamble.tex old/flat.tex new/flat.tex > virtio-diff.tex
perl -pi fixupdiff.pl virtio-diff.tex
SPECDOC="${SPECDOC}-diff"
rm $SPECDOC.aux $SPECDOC.pdf $SPECDOC.out
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
