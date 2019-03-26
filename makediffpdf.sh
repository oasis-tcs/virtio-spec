#make pdf diff using latexpand and latexdiff-fast
./makediff.sh virtio.tex || exit 3
SPECDOC=${SPECDOC:-`cat REVISION`}
FROMVERSION=${FROMVERSION:-`cat DIFFVERSION`}
SPECDOC="${SPECDOC}-diff-from-${FROMVERSION}"
rm $SPECDOC.aux $SPECDOC.pdf $SPECDOC.out
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
xelatex --jobname $SPECDOC virtio-diff.tex
