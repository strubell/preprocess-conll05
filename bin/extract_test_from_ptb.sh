#!/bin/bash
# Extract words and gold syntactic parses from PTB for the CoNLL-2005 dev set

# dev sections
SECTIONS="23"

mkdir -p $CONLL05/test.wsj/words
mkdir -p $CONLL05/test.wsj/synt

for section in $SECTIONS; do
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 1 | awk '{print $1}' | gzip > $CONLL05/test.wsj/words/test.wsj.${section}.words.gz
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 0 -p 1 | gzip > $CONLL05/test.wsj/synt/test.wsj.${section}.synt.gz
done
