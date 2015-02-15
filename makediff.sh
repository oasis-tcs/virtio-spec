#force revision and date in environment
#this way they don't appear in the diff
export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}

#make pdf diff using latexpand and latexdiff-fast
#preamble in diffpreamble.tex
#in diff, links are coloured green instead of blue
MAIN=$1
PATH=.:${PATH}
cur="$PWD"
oldrev=`git rev-list -1 origin/tags/v1.0-cs01`
newrev=`git rev-list -1 HEAD`
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout $oldrev
##suppress diff of title
#git cherry-pick 0adee486ab987c3e98c5f31b51cc963d8bb6fff4
##suppress diff of changelog
#git cherry-pick a41f3813a748e7d279cb6eb82f3c0afde4a3243a
#git cherry-pick fbfb402e69cdd9279c44b7684612e6f81df99e6d
#git cherry-pick 9f240fe0e718bf9b1e502e02916db9d8fede304b
#git cherry-pick a02605f9945f450ecaadf86736741de2e2c2e788
#git cherry-pick 175e797beede8aea840102bee9b70bb08190153d
while read -r rev; do
	echo "Applying $rev"
	git cherry-pick `git rev-list -1 -F --grep "$rev" $newrev` || exit 1
done << 'EOF'
formatting: escape \ldots in lstlisting
formatting: mark change manually as changed in cs02
cl: remove changelog for cs01
cl-os: prepare changelog for v1.0 cs02
title: update previous version to cs01
changelog: list acknowledgement change
changelog: typo fixup: formatting: formatting
EOF

#mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
#sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
#wget http://www.ctan.org/pkg/latexpand
#chmod +x latexpand
latexpand $MAIN -o flat.tex
cd "${cur}"
git clone $PWD new
cd "${cur}/new"
#mv specvars.tex specvars-orig.tex
#make links green to avoid confusion
#sed s/blue/pinegreen/ specvars-orig.tex > specvars.tex
SPECDOC=${SPECDOC:-`cat REVISION`}
./make-setup-generated.sh "$SPECDOC"
latexpand $MAIN -o flat.tex
cd "${cur}"
# latexdiff does not do diffs within footnotes
# adding space make it not realize the text is a footnote,
# and treat it normally
sed 's/\\footnote{/\\footnote {/' old/flat.tex > old/flat-fixed.tex
sed 's/\\footnote{/\\footnote {/' new/flat.tex > new/flat-fixed.tex
#cp old/flat.tex old/flat-fixed.tex
#cp new/flat.tex new/flat-fixed.tex
#wget http://mirror.math.ku.edu/tex-archive/support/latexdiff/latexdiff-fast
#chmod +x latexdiff-fast
latexdiff-fast --config \
"FLOATENV=(?:figure|longtable|table|tabular|plate)[\w\d*@]*" \
 --append-safecmd=field --append-textcmd=mmioreg --ignore-warnings -p diffpreamble.tex old/flat-fixed.tex new/flat-fixed.tex > virtio-diff.tex
#perl -pi fixupdiff.pl virtio-diff.tex
