#!/bin/sh

SPECDOC=${SPECDOC:-virtio-v1.0-csd01}
./make-setup-generated.sh "$SPECDOC"

rm $SPECDOC.aux $SPECDOC.pdf
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
