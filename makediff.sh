#force revision and date in environment
#this way they don't appear in the diff
export SPECDOC=${SPECDOC:-`cat REVISION`}
export DATESTR=${DATESTR:-`cat REVISION-DATE`}
export FROMVERSION=${FROMVERSION:-`cat DIFFVERSION`}

#make pdf diff using latexpand and latexdiff-fast
#preamble in diffpreamble.tex
#in diff, links are coloured green instead of blue
MAIN=$1
PATH=.:${PATH}
cur="$PWD"
oldrev=`git rev-list -1 tags/${FROMVERSION}`
newrev=`git rev-list -1 HEAD`
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout $oldrev
while read -r rev; do
	echo "Applying $rev"
	git cherry-pick --keep-redundant-commits --allow-empty `git rev-list -1 -F --grep "$rev" $newrev` || exit 1
done << 'EOF'
headerfile: rename virtio_ring to virtio queue
edit: drop obsolete commands related to cs02
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
#wget http://mirror.math.ku.edu/tex-archive/support/latexdiff/latexdiff-fast
#chmod +x latexdiff-fast
git submodule update latexdiff
ln -fs ./latexdiff/latexdiff ./latexdiff-fast
./latexdiff-fast \
 --append-safecmd=field --append-textcmd=mmioreg \
--append-textcmd=mmiodreg \
 --exclude-textcmd=chapter \
--ignore-warnings -p diffpreamble.tex old/flat.tex \
new/flat.tex > virtio-diff.tex
