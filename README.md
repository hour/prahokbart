# PrahokBART: A Pre-trained Sequence-to-Sequence Model for Khmer Natural Language Generation

This repository contains codes to reproduce the experimental results of [this paper](https://aclanthology.org/2025.coling-main.87/). Models are available on HuggingFace ([prahokbart_base](https://huggingface.co/nict-astrec-att/prahokbart_base) and [prahokbart_big](https://huggingface.co/nict-astrec-att/prahokbart_big))

# Dependencies
- Python >= 3.9.19
- [YANMTT](https://github.com/hour/yanmtt)
- [MOSES](https://github.com/moses-smt/mosesdecoder)
- `pip install sentence-splitter khmer-nltks`
- `pip install sacrebleu rouge_score`

# Pretraining
```
YANMTT=<path to the YANMTT tool>
MODEL_PATH=<model path>
TOKENIZER_PATH=<tokenizer path>
SRC_DATA_PATH=<source data path>
TGT_DATA_PATH=<target data path>
SRC=<source lang>
TGT=<target lang>
NUM_BATCHE=<number of batch>

$YANMTT/pretrain_nmt.py \
    --model_path $MODEL_PATH \
    --tokenizer_name_or_path $TOKENIZER_PATH \
    --langs ${SRC},${TGT} \
    --mono_src $SRC_DATA_PATH,$TGT_DATA_PATH \
    --num_batches $NUM_BATCHE \
    --encoder_layers 6 --decoder_layers 6 \
    --encoder_attention_heads 16 --decoder_attention_heads 16 \
    --encoder_ffn_dim 4096 --decoder_ffn_dim 4096 \
    --d_model 1024 \
    --token_masking_probs_range 0.35 --token_masking_lambda 3.5 \
    --max_length 1024 --hard_truncate_length 1020 \
    --batch_size 4096 \
    --dropout 0.1 --attention_dropout 0.1 --activation_dropout 0.1 \
    --label_smoothing 0.1 \
    --lr 0.001 --weight_decay 0.00001 --warmup_steps 16000 \
    --data_sampling_temperature 5.0 --sorted_batching \
    --shard_files
```

# Finetuning
You need to change four lines of code in `train_nmt.py` and `decode_nmt.py` in the YANMTT tool to support the prahokbart models.

You can find and replace `"IndicBART" in args.pretrained_model:` with `"IndicBART" in args.pretrained_model or "prahokbart" in args.pretrained_model:`

Finetuning on each downstream task:
- [Traslation](translation/)
- [Text Summarization](summarization/)
- [Headline Generation](headline/)

# Citation
If you use any codes in this repository, please cite this following paper:
```
@inproceedings{kaing2025prahokbart,
  title={PrahokBART: A Pre-trained Sequence-to-Sequence Model for Khmer Natural Language Generation},
  author={Kaing, Hour and Dabre, Raj and Song, Haiyue and Tran, Van-Hien and Tanaka, Hideki and Utiyama, Masao},
  booktitle={Proceedings of the 31st International Conference on Computational Linguistics},
  pages={1309--1322},
  year={2025}
}
```

# License
This software is published under the MIT-license.

# Acknowledgement
`utils/khnormal.py` is extended from [khnormal](https://github.com/sillsdev/khmer-character-specification/blob/master/python/scripts/khnormal)