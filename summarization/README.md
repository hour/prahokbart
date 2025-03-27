# Finetuning on LR-Sum summarization dataset

### Download LR-Sum dataset
```
cd raw
sh donwload.sh
cd ..
```

### Data preparation
```
sh prepare.sh
```

### Finetuning
```
CUDA_DEVICES=0,1,2,3,4,5,6,7 sh run.sh
```

### Translation and Evaluation
```
sh generate.sh
sh eval.sh
cat outputs/log.score.txt
```