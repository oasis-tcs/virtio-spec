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
oldrev=`git rev-list -1 origin/tags/v1.0-cs03`
newrev=`git rev-list -1 HEAD`
rm -fr old new
git clone $PWD old
cd "${cur}/old"
git checkout $oldrev
while read -r rev; do
	echo "Applying $rev"
	git cherry-pick `git rev-list -1 -F --grep "$rev" $newrev` || exit 1
done << 'EOF'
headerfile: rename virtio_ring to virtio queue
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
"FLOATENV=(?:figure|longtable|table|tabular|plate|lstlisting|note|enumerate|itemize)[\w\d*@]*,PICTUREENV=(?:picture|DIFdeltextcstwo|DIFnomarkup|lstlisting)[\w\d*@]*" \
 --append-safecmd=field --append-textcmd=mmioreg \
 --exclude-textcmd=chapter \
--ignore-warnings -p diffpreamble.tex old/flat-fixed.tex \
new/flat-fixed.tex > virtio-diff-tofix.tex
perl fixupdiff.pl virtio-diff-tofix.tex > virtio-diff.tex
