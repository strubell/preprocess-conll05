#!/bin/bash
# Extract words and gold syntactic parses from PTB for the CoNLL-2005 dev set

# dev sections
SECTIONS="01 02 03"

mkdir -p $CONLL05/test.brown/synt

rm $CONLL05/test.brown/synt/test.brown.synt.gz

for section in $SECTIONS; do
    cat $BROWN/CK/CK$section.MRG | awk '{if($1 !~ "*x*") print}' | $SRLCONLL/bin/wsj-removetraces.pl | $SRLCONLL/bin/wsj-to-se.pl -w 0 -p 1 | gzip >> $CONLL05/test.brown/synt/test.brown.synt.gz
done
