#!/bin/bash

src='km'
trg='km'

rawdir=../summarization/raw/data
datadir=data; mkdir -p $datadir

for dtype in test val train;
do
    cat $rawdir/$dtype.summary > $datadir/$dtype.summary.$src || exit 0
    cat $rawdir/$dtype.title > $datadir/$dtype.title.$trg || exit 0
done



