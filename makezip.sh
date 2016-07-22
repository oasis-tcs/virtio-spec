export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
rm -f $SPECDOC.zip
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
rm -fr listings
mkdir -p listings
cp virtio-queue.h listings/virtio_queue.h
zip $SPECDOC.zip listings/virtio_queue.h
rm -fr tmpfilesforzip
mkdir -p tmpfilesforzip/tex
echo "$SPECDOC" > tmpfilesforzip/tex/REVISION
echo "$DATESTR" > tmpfilesforzip/tex/REVISION-DATE
cd tmpfilesforzip
zip ../$SPECDOC.zip tex/*
