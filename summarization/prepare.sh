#!/bin/bash

src='km'
trg='km'

rawdir=raw/data
datadir=data; mkdir -p $datadir

for dtype in test val train;
do
    cat $rawdir/$dtype.text > $datadir/$dtype.text.$src || exit 0
    cat $rawdir/$dtype.summary > $datadir/$dtype.summary.$trg || exit 0
done



