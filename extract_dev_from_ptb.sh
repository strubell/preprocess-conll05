#!/bin/bash
# Extract words and gold syntactic parses from PTB for the CoNLL-2005 dev set

# dev sections
SECTIONS="24"

mkdir -p $CONLL05/devel/words
mkdir -p $CONLL05/devel/synt

for section in $SECTIONS; do
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 1 | awk '{print $1}' | gzip > $CONLL05/devel/words/devel.${section}.words.gz
    cat $WSJ/$section/* | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 0 -p 1 | gzip > $CONLL05/devel/synt/devel.${section}.synt.wsj.gz
done
