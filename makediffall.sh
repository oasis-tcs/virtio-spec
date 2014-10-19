export SPECDOC=${SPECDOC:-`cat REVISION`}
./makezip.sh
./makehtml.sh
./makediffhtml.sh
./makepdf.sh
./makediffpdf.sh
zip $SPECDOC.zip $SPECDOC.pdf $SPECDOC-diff.html $SPECDOC-diff.css $SPECDOC-diff.pdf
echo Generated file $SPECDOC.zip
echo To change output file name, set SPECDOC environment variable
echo Examples:
echo     SPECDOC=virtio-v1.0-wd01 $0
echo     SPECDOC=virtio-v1.0-csd01 $0
echo     SPECDOC=virtio-v1.0-csprd01 $0
echo     SPECDOC=virtio-v1.0-cs01 $0
echo     SPECDOC=virtio-v1.0-os $0
