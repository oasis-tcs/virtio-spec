export SPECDOC=${SPECDOC:-`cat REVISION`}
rm -f $SPECDOC
if test -d .git; then
	git archive --format=zip --prefix=tex/ -o $SPECDOC.zip HEAD
elif test -d .svn; then
	rm -fr export-from-svn
	mkdir -p export-from-svn
	svn export . export-from-svn/tex
	cd export-from-svn/
	zip ../$SPECDOC.zip tex/
	cd ..
else
	echo Neither .git nor .svn found.
	echo Falling back to generated list.
fi
zip -d $SPECDOC.zip tex/.gitattributes
mkdir -p listings
cp virtio-ring.h listings/virtio_ring.h
zip $SPECDOC.zip listings/virtio_ring.h
