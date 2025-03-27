#!/bin/bash

wget https://github.com/bltlab/lr-sum/releases/download/v1.0/khm.tgz
tar -xzvf khm.tgz

mkdir -p data

for dtype in test val train;
do
    python format.py khm/khm_$dtype.jsonl data/$dtype || exit 0
done
