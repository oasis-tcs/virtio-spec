#!/bin/sh

SPECDOC=virtio-v1.0-csd01

rm $SPECDOC.aux
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
xelatex --jobname $SPECDOC virtio.tex
