export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
export FROMVERSION=${FROMVERSION:-`cat DIFFVERSION`}
./makezip.sh
mv -f $SPECDOC.zip $SPECDOC-diff-from-${FROMVERSION}.pdf
./makediffhtml.sh
./makediffpdf.sh
zip $SPECDOC-diff-from-${FROMVERSION}.zip \
	$SPECDOC-diff-from-${FROMVERSION}.pdf
echo Generated file $SPECDOC.zip
echo To change output file name, set SPECDOC environment variable
echo Examples:
echo     SPECDOC=virtio-v1.0-wd01 $0
echo     SPECDOC=virtio-v1.0-csd01 $0
echo     SPECDOC=virtio-v1.0-csprd01 $0
echo     SPECDOC=virtio-v1.0-cs01 $0
echo     SPECDOC=virtio-v1.0-os $0
