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

