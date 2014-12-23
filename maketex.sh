export SPECDOC=${SPECDOC:-`cat REVISION`}-tex
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
./makezip.sh
