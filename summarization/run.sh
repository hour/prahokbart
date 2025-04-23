#!/bin/bash

py=python
yanmtt=../yanmtt

src='km'
trg='km'

datadir=data
modeldir=models; mkdir -p $modeldir

ls $datadir/train.text.$src* | egrep 'data/train.text\..+\.[0-9]+' | xargs rm -f
ls $datadir/train.summary.$trg* | egrep 'data/train.summary\..+\.[0-9]+' | xargs rm -f

if [ -z $CUDA_DEVICES ]; then
    CUDA_DEVICES=0
fi

if [ -z $PORT ]; then
    PORT=26023
fi

pretrained_name=nict-astrec-att/prahokbart_big

# CUDA_LAUNCH_BLOCKING=1 \
# PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
CUDA_VISIBLE_DEVICES=$CUDA_DEVICES \
$py $yanmtt/train_nmt.py -n 1 -nr 0 -g 1 -p $PORT \
    --is_summarization --use_rouge \
    --model_path $modeldir/models/nmt \
    --use_official_pretrained --use_official_pretrained_tokenizer \
    --pretrained_model $pretrained_name \
    --tokenizer_name_or_path $pretrained_name \
    --train_slang $src --train_tlang $trg \
    --dev_slang $src --dev_tlang $trg \
    --train_src $datadir/train.text.$src --train_tgt $datadir/train.summary.$trg \
    --dev_src $datadir/val.text.$src --dev_tgt $datadir/val.summary.$trg \
    --batch_size 2048 --label_smoothing 0.1 \
    --dropout 0.1 --activation_dropout 0.1 \
    --warmup_steps 16000 --weight_decay 0.00001 \
    --lr 0.001 --max_gradient_clip_value 1.0 \
    --dev_batch_size 64 \
    --max_src_length 512 --max_tgt_length 64 \
    --hard_truncate_length 510 \
    --length_penalty 1.2 \
    --early_stop_checkpoints 20 \
    --eval_on_tokenized \
    --shard_files
