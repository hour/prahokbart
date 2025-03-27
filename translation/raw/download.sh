#!/bin/bash

url_altbased="https://www2.nict.go.jp/astrec-att/member/mutiyama/ALT"
url_altraw="$url_altbased/ALT-Parallel-Corpus-20191206.zip"

altdir='ALT-Parallel-Corpus'
mkdir -p $altdir

pushd $altdir

wget $url_altraw || exit 0
wget $url_altbased/URL-train.txt || exit 0
wget $url_altbased/URL-dev.txt || exit 0
wget $url_altbased/URL-test.txt || exit 0
wget $url_altbased/tools.zip || exit 0

unzip ALT-Parallel-Corpus-20191206.zip || exit 0
unzip tools.zip || exit 0

mv ALT-Parallel-Corpus-20191206 ALT-Parallel-Corpus-20190531

cd tools; sh doit.sh

popd