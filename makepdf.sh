#!/bin/sh

SPECDOC=${SPECDOC:-virtio-v1.0-csd01}

rm $SPECDOC.aux $SPECDOC.pdf
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
