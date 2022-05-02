export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
./makezip.sh
./makehtml.sh
./makepdf.sh
zip $SPECDOC.zip $SPECDOC.pdf
for version in v1.1-cs01 v1.2-wd01; do
	export FROMVERSION="${version}"
	mv -f $SPECDOC.zip $SPECDOC-diff-from-${FROMVERSION}.zip
	./makediffhtml.sh
	./makediffpdf.sh
	zip $SPECDOC-diff-from-${FROMVERSION}.zip $SPECDOC-diff-from-${FROMVERSION}.pdf
	mv -f $SPECDOC-diff-from-${FROMVERSION}.zip ${SPECDOC}.zip
done
mv -f $SPECDOC.zip ${SPECDOC}-diffs.zip
echo Generated file $SPECDOC-diffs.zip
echo To change output file name, set SPECDOC environment variable
echo Examples:
echo     SPECDOC=virtio-v1.0-wd01 $0
echo     SPECDOC=virtio-v1.0-csd01 $0
echo     SPECDOC=virtio-v1.0-csprd01 $0
echo     SPECDOC=virtio-v1.0-cs01 $0
echo     SPECDOC=virtio-v1.0-os $0

