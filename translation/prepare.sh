#!/bin/bash

py=python
mosesdecoder=../mosesdecoder
predir=../utils

src='en'
trg='km'

rawdir=raw
datadir=data; mkdir -p $datadir
models=$datadir/models; mkdir -p $models

for lang in en km;
do
    for dtype in test dev train;
    do
        cut -f2- $rawdir/ALT-Parallel-Corpus/tools/data_$(echo $lang|sed 's/km/khm/g').txt.$dtype > $rawdir/$dtype.$lang || exit 0
    done
done

for dtype in test dev train;
do
    $py $predir/khnormal.py $rawdir/$dtype.km $datadir/$dtype.norm.km \
        --invisible-chars $predir/invisible_chars.txt --n-workers 16 || exit 0
    $py $predir/khtokenize.py $datadir/$dtype.norm.km $datadir/$dtype.km --keep-space --n-workers 16 || exit 0
done

########## preprocess English

# tokenization
$mosesdecoder/scripts/tokenizer/tokenizer.perl -l en \
 < $rawdir/train.en > $datadir/train.tok.en || exit 0

# truecase
$mosesdecoder/scripts/recaser/train-truecaser.perl \
 --model $models/truecase-model.en \
 --corpus $datadir/train.tok.en || exit 0

$mosesdecoder/scripts/recaser/truecase.perl \
 --model $models/truecase-model.en \
 < $datadir/train.tok.en > $datadir/train.en || exit 0

rm $datadir/train.tok.en

for dtype in test dev;
do
    cat $rawdir/$dtype.en \
     | $mosesdecoder/scripts/tokenizer/tokenizer.perl -l en \
     | $mosesdecoder/scripts/recaser/truecase.perl --model $models/truecase-model.en \
     > $datadir/$dtype.en.tmp || exit 0

    mv $datadir/$dtype.en.tmp $datadir/$dtype.en
done



