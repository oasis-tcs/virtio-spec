export SPECDOC=${SPECDOC:-virtio-v1.0-wd01}
rm -f $SPECDOC
git archive --format=zip --prefix=tex/ -o $SPECDOC.zip HEAD
zip -d $SPECDOC.zip tex/.gitattributes
./makehtml.sh
./makepdf.sh
zip $SPECDOC.zip $SPECDOC.pdf
mkdir -p listings
cp virtio-ring.h listings/virtio_ring.h
zip $SPECDOC.zip listings/virtio_ring.h
echo Generated file $SPECDOC.zip
echo To change output file name, set SPECDOC environment variable
echo Examples:
echo     SPECDOC=virtio-v1.0-wd01 $0
echo     SPECDOC=virtio-v1.0-csd01 $0
echo     SPECDOC=virtio-v1.0-csprd01 $0
echo     SPECDOC=virtio-v1.0-os $0
