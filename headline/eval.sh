#!/bin/bash

py=python

datadir='data'

src='km'
trg='km'

outputdir=outputs

$py -m rouge_score.rouge \
    --target_filepattern=$datadir/test.title.$trg \
    --prediction_filepattern=$outputdir/test.title.$trg \
    --output_filename=$outputdir/log.score.txt \
    --use_stemmer=false \
    --lang="khmer"

cat $outputdir/log.score.txt || exit 0

########## drop funtional spaces
cat $datadir/test.title.$trg | sed 's/ ▂ / /g' > $datadir/test.title.nospace.$trg || exit 0
cat $outputdir/test.title.$trg | sed 's/ ▂ / /g' > $outputdir/test.title.nospace.$trg || exit 0

$py -m rouge_score.rouge \
    --target_filepattern=$datadir/test.title.nospace.$trg \
    --prediction_filepattern=$outputdir/test.title.nospace.$trg \
    --output_filename=$outputdir/log.score.nospace.txt \
    --use_stemmer=false \
    --lang="khmer"

cat $outputdir/log.score.nospace.txt || exit 0