#!/bin/bash

py=python
yanmtt=../yanmtt

src='km'
trg='km'

datadir=data
modeldir=models
outputdir=outputs; mkdir -p $outputdir

if [ -z $PORT ]; then
    PORT=26023
fi

pretrained_name=nict-astrec-att/prahokbart_big

CUDA_VISIBLE_DEVICES=0 \
$py $yanmtt/decode_nmt.py -n 1 -nr 0 -g 1 -p $PORT \
    --use_official_pretrained --use_official_pretrained_tokenizer \
    --model_path $pretrained_name \
    --locally_fine_tuned_model_path $modeldir/models/nmt.best_dev_bleu.global \
    --tokenizer_name_or_path $pretrained_name \
    --hard_truncate_length 1020 \
    --slang $src --tlang $trg \
    --test_src $datadir/test.text.$src --test_tgt $outputdir/test.summary.$trg \
    --test_ref $datadir/test.summary.$trg || exit 0

