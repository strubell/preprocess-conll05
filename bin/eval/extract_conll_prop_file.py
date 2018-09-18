from __future__ import print_function
import argparse
import gzip

arg_parser = argparse.ArgumentParser(description='Convert a CoNLL-2012 file to CoNLL-2005 prop format')
arg_parser.add_argument('--input_file', type=str, help='File to process')
arg_parser.add_argument('--word_field', type=int, help='Field containing words')
arg_parser.add_argument('--pred_field', type=int, help='Field containing predicates')
# arg_parser.add_argument('--pred_field_offset', type=int, help='Offset for predicates field', default=1)
arg_parser.add_argument('--take_last', dest='take_last', action='store_true')
arg_parser.add_argument('--no_take_last', dest='take_last', action='store_false')
arg_parser.set_defaults(take_last=False)
arg_parser.add_argument('--domain', dest='domain')
arg_parser.set_defaults(domain='-')

arg_parser.add_argument('--first_prop_field', type=int, help='First field containing props')

args = arg_parser.parse_args()


with gzip.open(args.input_file, 'r') if args.input_file.endswith('gz') else open(args.input_file, 'r') as f:
  print_newline = False
  for line in f:
    line = line.strip()
    if line:
      split_line = line.strip().split()
      domain = split_line[0].split('/')[0]
      if args.domain == '-' or domain == args.domain:
        print_newline = True
        props = split_line[args.first_prop_field:] if args.take_last else split_line[args.first_prop_field:-1]
        word = split_line[args.word_field] if split_line[args.pred_field] != '-' else '-'
        new_fields = [word] + props
        new_line = '\t'.join(new_fields)
        print(new_line)
    else:
      if print_newline:
        print_newline = False
        print()
