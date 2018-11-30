#! /bin/sh

VERSION=1.1
DATESTR=${DATESTR:-`cat REVISION-DATE 2>/dev/null`}
if [ x"$DATESTR" = x ]; then
    ISODATE=`git show --format=format:'%cd' --date=iso | head -n 1`
    DATESTR=`date -d "$DATE" +'%d %B %Y'`
fi

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
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	;;
    *-csprd*)
	STAGE=csprd
	WORKINGDRAFT=`basename "$1" | sed 's/.*-csprd//'`
	STAGENAME="Committee Specification Draft $WORKINGDRAFT"
	STAGEEXTRATITLE=" / \newline Public Review Draft $WORKINGDRAFT"
	STAGEEXTRA=" / Public Review Draft $WORKINGDRAFT"
	;;
    *-cs*)
	STAGE=cs
	WORKINGDRAFT=`basename "$1" | sed 's/.*-cs//'`
	STAGENAME="Committee Specification $WORKINGDRAFT"
	;;
    *)
	echo Unknown doc type >&2
	exit 1
esac

#Prepend OASIS unless already there
case "$STAGENAME" in
	OASIS*)
		OASISSTAGENAME="$STAGENAME"
		;;
	*)
		OASISSTAGENAME="OASIS $STAGENAME"
		;;
esac

cat > setup-generated.tex <<EOF
% define VIRTIO Working Draft number and date
\newcommand{\virtiorev}{$VERSION}
\newcommand{\virtioworkingdraftdate}{$DATESTR}
\newcommand{\virtioworkingdraft}{$WORKINGDRAFT}
\newcommand{\virtiodraftstage}{$STAGE}
\newcommand{\virtiodraftstageextra}{$STAGEEXTRA}
\newcommand{\virtiodraftstageextratitle}{$STAGEEXTRATITLE}
\newcommand{\virtiodraftstagename}{$STAGENAME}
\newcommand{\virtiodraftoasisstagename}{$OASISSTAGENAME}
EOF
