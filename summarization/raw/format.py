import json, codecs
from tqdm import tqdm

if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('input')
    parser.add_argument('output_prefix')
    args = parser.parse_args()

    with codecs.open(args.input, 'r', 'utf-8') as fin, \
    codecs.open(f'{args.output_prefix}.title', 'w', 'utf-8') as ftitle, \
    codecs.open(f'{args.output_prefix}.summary', 'w', 'utf-8') as fsummary, \
    codecs.open(f'{args.output_prefix}.text', 'w', 'utf-8') as ftext:
        for line in tqdm(fin):
            line = json.loads(line)
            print(line['title'].strip(), file=ftitle)
            print(line['summary'].strip(), file=fsummary)
            print(line['text'].strip(), file=ftext)