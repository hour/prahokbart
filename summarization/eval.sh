#!/bin/bash

py=python

datadir='data'

src='km'
trg='km'

outputdir=outputs

$py -m rouge_score.rouge \
    --target_filepattern=$datadir/test.summary.$trg \
    --prediction_filepattern=$outputdir/test.summary.$trg \
    --output_filename=$outputdir/log.score.txt \
    --use_stemmer=false \
    --lang="khmer"

cat $outputdir/log.score.txt || exit 0

########## drop funtional spaces
cat $datadir/test.summary.$trg | sed 's/ ▂ / /g' > $datadir/test.summary.nospace.$trg || exit 0
cat $outputdir/test.summary.$trg | sed 's/ ▂ / /g' > $outputdir/test.summary.nospace.$trg || exit 0

$py -m rouge_score.rouge \
    --target_filepattern=$datadir/test.summary.nospace.$trg \
    --prediction_filepattern=$outputdir/test.summary.nospace.$trg \
    --output_filename=$outputdir/log.score.nospace.txt \
    --use_stemmer=false \
    --lang="khmer"

cat $outputdir/log.score.nospace.txt || exit 0