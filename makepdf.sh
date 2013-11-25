#!/bin/sh

SPECDOC=virtio-v1.0-csd01

rm $SPECDOC.aux
xelatex $SPECDOC.tex
xelatex $SPECDOC.tex
xelatex $SPECDOC.tex
