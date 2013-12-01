#!/bin/sh

SPECDOC=${SPECDOC:-virtio-v1.0-csd01}

cp virtio-html.tex $SPECDOC.tex

#uncomment if you have a broken t4ht
#PATH=./t4ht-workaround:${PATH} htlatex $SPECDOC.tex "virtiohtml,info,charset=utf-8" " -cunihtf -utf8"
htlatex $SPECDOC.tex "virtio-html,info,charset=utf-8" " -cunihtf -utf8"

rm $SPECDOC.tex

rm $SPECDOC.aux
mv $SPECDOC.html $SPECDOC.tmp1

sed 's/~~/"/g' $SPECDOC.tmp1 >$SPECDOC.tmp2
sed 's/>~/>"/g' $SPECDOC.tmp2 >$SPECDOC.tmp3
sed 's/>=~/>="/g' $SPECDOC.tmp3 >$SPECDOC.tmp4
sed 's/~</"</g' $SPECDOC.tmp4 >$SPECDOC.tmp5

#For some unclear reason we get 'fi' replaced by NULL character
# on Fedora. file recognizes result as a binary data.
# Detect and work around this.
if test `file -b $SPECDOC.tmp5` = 'data';
then
	perl -p -e 's/\0/fi/g' $SPECDOC.tmp5 >$SPECDOC.tmp6
else
	cp $SPECDOC.tmp5 $SPECDOC.tmp6
fi

mv $SPECDOC.tmp6 $SPECDOC.html
rm $SPECDOC.tmp*

#uncomment if you have a broken t4ht
#cp ./t4ht-workaround/virtio-v1.0-csd01.css $SPECDOC.css

zip $SPECDOC.zip $SPECDOC.html $SPECDOC.css images/*.png
