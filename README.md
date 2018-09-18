# preprocess-conll05
Scripts for preprocessing the CoNLL-2005 SRL dataset.

## Basic CoNLL-2005 pre-processing 
These pre-processing steps download the CoNLL-2005 data and gather gold part-of-speech 
and parse info from your copies of the PTB and Brown corpora. The output will look like:
```
The         DT    (S(NP-SBJ-1(NP*  *    -   -      (A1*      
economy     NN    *                *    -   -      *      
's          POS   *)               *    -   -      *      
temperature NN    *)               *    -   -      *)     
will        MD    (VP*             *    -   -      (AM-MOD*)     
be          VB    (VP*             *    -   -      *      
taken       VBN   (VP*             *    01  take   (V*) 
```

- Field 1: word form
- Field 2: gold part-of-speech tag
- Field 3: gold sytax
- Field 4: placeholder
- Field 5: verb sense
- Field 6: predicate (infinitive form)
- Field 7+: for each predicate, a column representing the labeled arguments of the predicate.

First, set up paths to existing data:
```bash
export WSJ="/your/path/to/wsj/"
export BROWN="/your/path/to/brown"
```

Download CoNLL-2005 data and scripts:
```bash
./bin/get_data.sh
```

Extract pos/parse info from gold data:
```bash
./bin/extract_train_from_ptb.sh
./bin/extract_dev_from_ptb.sh
./bin/extract_test_from_ptb.sh
./bin/extract_test_from_brown.sh
```

Format into combined output files:
```bash
./bin/make-trainset.sh
./bin/make-devset.sh 
./bin/make-wsj-test.sh
./bin/make-brown-test.sh 
```

## Further pre-processing (e.g. for [LISA](https://github.com/strubell/LISA))
Sometimes it's nice to convert constituencies to dependency parses and provide automatic
part-of-speech tags, e.g. if you wish to train a parsing model. BIO format is also a 
more standard way of representing spans than the default CoNLL-2005 format. This pre-processing
converts the constituency parses to Stanford dependencies (v3.5), assigns automatic part-of-speech
tags from the Stanford left3words tagger, and converts SRL spans to BIO format. The output will look like:

```
conll05 0       0       The         DT      DT      2       det         _       -       -       -       -       O       B-A1
conll05 0       1       economy     NN      NN      4       poss        _       -       -       -       -       O       I-A1
conll05 0       2       's          POS     POS     2       possessive  _       -       -       -       -       O       I-A1
conll05 0       3       temperature NN      NN      7       nsubjpass   _       -       -       -       -       O       I-A1
conll05 0       4       will        MD      MD      7       aux         _       -       -       -       -       O       B-AM-MOD
conll05 0       5       be          VB      VB      7       auxpass     _       -       -       -       -       O       O
conll05 0       6       taken       VBN     VBN     0       root        _       01      take    -       -       O       B-V
```

- Field 1: domain placeholder
- Field 2: sentence id
- Field 3: token id
- Field 4: word form
- Field 5: gold part-of-speech tag
- Field 6: auto part-of-speech tag
- Field 7: dependency parse head
- Field 8: dependency parse label
- Field 9: placeholder
- Field 10: verb sense
- Field 11: predicate (infinitive form)
- Field 12: placeholder
- Field 13: placeholder
- Field 14: NER placeholder
- Field 15+: for each predicate, a column representing the labeled arguments of the predicate.


