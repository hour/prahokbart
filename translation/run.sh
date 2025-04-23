#!/bin/bash

py=python
yanmtt=../yanmtt

src='en'
trg='km'

datadir=data
modeldir=models; mkdir -p $modeldir

ls $datadir/train.$src* | egrep 'data/train\..+\.[0-9]+' | xargs rm -f
ls $datadir/train.$trg* | egrep 'data/train\..+\.[0-9]+' | xargs rm -f

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
$py $yanmtt/train_nmt.py -n 1 -nr 0 -g 1 -p $PORT $args \
    --model_path $modeldir/models/nmt \
    --use_official_pretrained --use_official_pretrained_tokenizer \
    --pretrained_model $pretrained_name \
    --tokenizer_name_or_path $pretrained_name \
    --train_slang $src --train_tlang $trg \
    --dev_slang $src --dev_tlang $trg \
    --train_src $datadir/train.$src --train_tgt $datadir/train.$trg \
    --dev_src $datadir/dev.$src --dev_tgt $datadir/dev.$trg \
    --batch_size 2048 --label_smoothing 0.1 \
    --dropout 0.1 --activation_dropout 0.1 \
    --warmup_steps 16000 --weight_decay 0.00001 \
    --lr 0.001 --max_gradient_clip_value 1.0 \
    --dev_batch_size 64 \
    --hard_truncate_length 256 --early_stop_checkpoints 20 \
    --eval_on_tokenized \
    --shard_files
