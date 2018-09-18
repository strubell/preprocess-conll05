#!/bin/bash
# Extract words and gold syntactic parses from PTB for the CoNLL-2005 train set

# train sections
SECTIONS="02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21"

mkdir -p $CONLL05/train/words
mkdir -p $CONLL05/train/synt

for section in $SECTIONS; do
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 1 | awk '{print $1}' | gzip > $CONLL05/train/words/train.${section}.words.gz
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 0 -p 1 | gzip > $CONLL05/train/synt/train.${section}.synt.wsj.gz
done
