import argparse
import gzip

arg_parser = argparse.ArgumentParser(description='Convert a CoNLL-2012 file to CoNLL-X format')
arg_parser.add_argument('--input_file', type=str, help='File to process')
arg_parser.add_argument('--word_field', type=int, help='Field containing words')
arg_parser.add_argument('--pos_field', type=int, help='Field containing gold part-of-speech tags')
arg_parser.add_argument('--head_field', type=int, help='Field containing gold parse head')
arg_parser.add_argument('--label_field', type=int, help='Field containing gold parse label')
arg_parser.add_argument('--id_field', type=int, help='Field containing word id')
arg_parser.add_argument('--drop_single_tokens', dest='drop_single_tokens', action='store_true')
arg_parser.add_argument('--no_drop_single_tokens', dest='drop_single_tokens', action='store_false')
arg_parser.set_defaults(drop_single_tokens=False)

arg_parser.add_argument('--domain', dest='domain')
arg_parser.set_defaults(domain='-')

args = arg_parser.parse_args()

# ID: Word index, integer starting at 1 for each new sentence; may be a range for multiword tokens; may be a decimal number for empty nodes.
# FORM: Word form or punctuation symbol.
# LEMMA: Lemma or stem of word form.
# UPOSTAG: Universal part-of-speech tag.
# XPOSTAG: Language-specific part-of-speech tag; underscore if not available.
# FEATS: List of morphological features from the universal feature inventory or from a defined language-specific extension; underscore if not available.
# HEAD: Head of the current word, which is either a value of ID or zero (0).
# DEPREL: Universal dependency relation to the HEAD (root iff HEAD = 0) or a defined language-specific subtype of one.
# DEPS: Enhanced dependency graph in the form of a list of head-deprel pairs.
# MISC: Any other annotation.
with gzip.open(args.input_file, 'r') if args.input_file.endswith('gz') else open(args.input_file, 'r') as f:
  # print_newline = False
  word_idx = 1
  buf = []
  for line in f:
    line = line.strip()
    if line:
      split_line = line.strip().split()
      domain = split_line[0].split('/')[0]
      if args.domain == '-' or domain == args.domain:
        # print_newline = True
        word = split_line[args.word_field]
        id = split_line[args.id_field]
        if id == '_':
          id = word_idx
        else:
          id = int(split_line[args.id_field]) + 1
        pos = split_line[args.pos_field]
        head = split_line[args.head_field]
        label = split_line[args.label_field]
        new_fields = [str(id), word, '_', pos, '_', '_', head, label]
        new_line = '\t'.join(new_fields)
        buf.append(new_line)
        # print(new_line)
        word_idx += 1
    else:
      word_idx = 1
      if buf:
        sent_len = len(buf)
        if not args.drop_single_tokens or sent_len > 1:
          for tok in buf:
            print(tok)
          print()
        buf = []
      # if print_newline:
      #   print_newline = False
      #   print()
  if buf:
    for tok in buf:
      print(tok)
    print()
