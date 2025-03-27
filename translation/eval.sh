#!/bin/bash

py=python
sacrebleu="$py -m sacrebleu"
mosesdecoder=../mosesdecoder

datadir='data'

src='en'
trg='km'

outputdir=outputs

cat $outputdir/test.$trg \
    | $mosesdecoder/scripts/recaser/detruecase.perl \
    | $mosesdecoder/scripts/tokenizer/detokenizer.perl -l en \
    | $mosesdecoder/scripts/generic/multi-bleu-detok.perl $datadir/test.$trg \
    > $outputdir/log.score.txt || exit 0

echo "sacrebleu: bleu, chrf, ter" >> $outputdir/log.score.txt || exit 0
cat $outputdir/test.$trg \
    | $mosesdecoder/scripts/recaser/detruecase.perl \
    | $mosesdecoder/scripts/tokenizer/detokenizer.perl -l en \
    | $sacrebleu $datadir/test.$trg -b -m bleu chrf ter -w 2 >> $outputdir/log.score.txt || exit 0

########## drop funtional spaces
cat $datadir/test.$trg | sed 's/ ▂ / /g' > $outputdir/test.ref.nospace.$trg || exit 0

echo "sacrebleu: bleu, chrf, ter" >> $outputdir/log.score.txt || exit 0
cat $outputdir/test.$trg | sed 's/ ▂ / /g' \
    | $mosesdecoder/scripts/recaser/detruecase.perl \
    | $mosesdecoder/scripts/tokenizer/detokenizer.perl -l en \
    | $sacrebleu $outputdir/test.ref.nospace.$trg -b -m bleu chrf ter -w 2 >> $outputdir/log.score.txt || exit 0

cat $outputdir/log.score.txt || exit 0
