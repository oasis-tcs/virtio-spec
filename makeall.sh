export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
./makezip.sh
./makehtml.sh
./makepdf.sh
zip $SPECDOC.zip $SPECDOC.pdf
echo Generated file $SPECDOC.zip
echo To change output file name, set SPECDOC environment variable
echo Examples:
echo     SPECDOC=virtio-v1.0-wd01 $0
echo     SPECDOC=virtio-v1.0-csd01 $0
echo     SPECDOC=virtio-v1.0-csprd01 $0
echo     SPECDOC=virtio-v1.0-cs01 $0
echo     SPECDOC=virtio-v1.0-os $0
