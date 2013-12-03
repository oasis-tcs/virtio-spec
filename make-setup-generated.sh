#! /bin/sh

case "$1" in
    *-wd*)
	STAGE=wd
	STAGENAME="Working Draft"
	WORKINGDRAFT=`basename "$1" | sed 's/.*-wd//'`
	;;
    *-os*)
	STAGE=os
	STAGENAME="OASIS Standard"
	WORKINGDRAFT=""
	;;
    *-csd*)
	STAGE=csd
	STAGENAME="Committee Specification Draft"
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csd//'`
	;;
    *-csprd*)
	STAGE=csprd
	STAGENAME="Committee Specification Public Review Draft"
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csprd//'`
	;;
    *-cs*)
	STAGE=cs
	STAGENAME="Committee Specification"
	WORKINGDRAFT=""
	;;
    *)
	echo Unknown doc type >&2
	exit 1
esac

VERSION=1.0
ISODATE=`git show --format=format:'%cd' --date=iso | head -n 1`
DATESTR=`date -d "$DATE" +'%d %b %Y'`
cat > setup-generated.tex <<EOF
% define VIRTIO Working Draft number and date
\newcommand{\virtiorev}{$VERSION}
\newcommand{\virtioworkingdraftdate}{$DATESTR}
\newcommand{\virtioworkingdraft}{$WORKINGDRAFT}
\newcommand{\virtiodraftstage}{$STAGE}
\newcommand{\virtiodraftstagename}{$STAGENAME}
EOF
