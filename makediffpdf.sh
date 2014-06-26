#make pdf diff using latexpand and latexdiff-fast
./makediff.sh virtio.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
SPECDOC="${SPECDOC}-diff"
rm $SPECDOC.aux $SPECDOC.pdf $SPECDOC.out
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
