from khmernltk import word_tokenize
from tqdm import tqdm
import re

def tokenize(line):
    return word_tokenize(line) + ['\n']

def tokenize_lines_iter(lines, show_progress=True, is_byte=False, from_stopes=False, keep_space=False):
    if show_progress:
        lines = tqdm(lines)

    func_encode = lambda x: x
    if is_byte:
        func_encode = lambda x: str(x, encoding='utf-8')

    func_csv = lambda x: x
    if from_stopes:
        func_csv = lambda x: x.split('\t')[5]

    func_space = lambda x: re.sub(r'   ', u' ', ' '.join(tokenize(line)))
    if keep_space:
        func_space = lambda x: re.sub(r'   ', u' \u2582 ', ' '.join(tokenize(line))) # ▂ is 'U+2582' which is the next symbols of "▁" used by SentencePiece

    for line in lines:
        yield func_space(func_csv(func_encode(line)))

def tokenize_lines(lines, show_progress=True, is_byte=False, from_stopes=False, keep_space=False):
    return list(tokenize_lines_iter(lines, show_progress, is_byte, from_stopes, keep_space))

if __name__ == "__main__":

    import argparse, codecs

    def readlines(iterlines, buffer_size=100000):
        lines = []
        for line in iterlines:
            lines.append(line)

            if len(lines) >= buffer_size:
                yield lines
                lines = []

        if len(lines) > 0:
            yield lines

    parser = argparse.ArgumentParser()
    parser.add_argument('input')
    parser.add_argument('output')
    parser.add_argument('--is-xz-file', action='store_true')
    parser.add_argument('--n-workers', type=int, default=0)
    parser.add_argument('--buffer-size', type=int, default=10000)
    parser.add_argument('--from-stopes', action='store_true')
    parser.add_argument('--keep-space', action='store_true')
    args = parser.parse_args()

    fin = codecs.open(args.input, 'r', 'utf-8')
    fout = codecs.open(args.output, 'w', 'utf-8')

    func_decode = lambda x: x

    if args.is_xz_file:
        try:
            import lzma
        except ImportError:
            from backports import lzma

        fin = lzma.open(args.input, mode='rb')
        fout = lzma.open(args.output, mode='w')
        func_decode = lambda x: bytes(x, encoding='utf-8')
        
    else:
        fin = codecs.open(args.input, 'r', 'utf-8')
        fout = codecs.open(args.output, 'w', 'utf-8')

    if args.n_workers < 2:
        for line in tokenize_lines_iter(fin, is_byte=args.is_xz_file, from_stopes=args.from_stopes, keep_space=args.keep_space):
            fout.write(func_decode(line))

    else:
        from multiprocessing import Pool
        pool = Pool(processes=args.n_workers)
        asynce_results = []

        for lines in tqdm(readlines(fin, buffer_size=args.buffer_size)):
            asynce_results.append(
                pool.apply_async(
                    tokenize_lines, (lines, False, args.is_xz_file, args.from_stopes, args.keep_space)
                )
            )

        pool.close()
        pool.join()

        for result in tqdm(asynce_results):
            for line in result.get():
                fout.write(func_decode(line))

    fin.close()
    fout.close()