#!/bin/sh

SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"

cp virtio-html.tex $SPECDOC.tex

#uncomment if you have a broken t4ht
#PATH=./t4ht-workaround:${PATH} htlatex $SPECDOC.tex "virtiohtml,info,charset=utf-8" " -cunihtf -utf8"
htlatex $SPECDOC.tex "virtio-html,info,charset=utf-8,fn-in" " -cunihtf -utf8"

rm $SPECDOC.tex

rm $SPECDOC.aux
mv $SPECDOC.html $SPECDOC.tmp1

sed 's/~~/"/g' $SPECDOC.tmp1 >$SPECDOC.tmp2
sed 's/>~/>"/g' $SPECDOC.tmp2 >$SPECDOC.tmp3
sed 's/>=~/>="/g' $SPECDOC.tmp3 >$SPECDOC.tmp4
sed 's/~</"</g' $SPECDOC.tmp4 >$SPECDOC.tmp5

# If font paths are misconfigured, we get ligatures
# (such as 'ff or 'fi') replaced by NULL character in output.
# This in not a valid HTML output, so detect this and warn user.
# For detection, we rely on the fact that file utility
# recognizes files with NULL characters as binary data.
if test "$(file -b $SPECDOC.tmp5)" = 'data';
then
	echo 
	echo WARNING!
	echo 
	echo NULL characters detected in file output.
	echo This is likely due to tex4ht being unable to find font files.
	echo If installed, you might need to fix font file paths
	echo for tex4ht by locating tex4ht.env file in your setup
	echo correcting font file paths there and copying it to
	echo tex4ht.env or .tex4ht in your home directory.
	echo 
	echo WARNING!
	echo Proceeding but HTML output appears to be malformed.
	echo 
fi

mv $SPECDOC.tmp5 $SPECDOC.html
rm $SPECDOC.tmp*

#uncomment if you have a broken t4ht
#cp ./t4ht-workaround/virtio-v1.0-csd01.css $SPECDOC.css

zip $SPECDOC.zip $SPECDOC*.html $SPECDOC.css images/*.png
