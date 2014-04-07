#!/bin/sh

SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"

rm $SPECDOC.aux $SPECDOC.pdf $SPECDOC.out
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
