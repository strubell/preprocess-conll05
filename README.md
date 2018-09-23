# preprocess-conll05
Scripts for preprocessing the CoNLL-2005 SRL dataset.

### Requirements:
- Python 3
- Bash
- A copy of the [Penn TreeBank](https://catalog.ldc.upenn.edu/ldc99t42)

## Basic CoNLL-2005 pre-processing 
These pre-processing steps download the CoNLL-2005 data and gather gold part-of-speech 
and parse info from your copy of the PTB. The output will look like:
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
./bin/basic/get_data.sh
```

Extract pos/parse info from gold data:
```bash
./bin/basic/extract_train_from_ptb.sh
./bin/basic/extract_dev_from_ptb.sh
./bin/basic/extract_test_from_ptb.sh
./bin/basic/extract_test_from_brown.sh
```

Format into combined output files:
```bash
./bin/basic/make-trainset.sh
./bin/basic/make-devset.sh 
./bin/basic/make-wsj-test.sh
./bin/basic/make-brown-test.sh 
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

First, set up paths to Stanford parser and part-of-speech tagger:
```bash
export STANFORD_PARSER="/your/path/to/stanford-parser-full-2017-06-09"
export STANFORD_POS="/your/path/to/stanford-postagger-full-2017-06-09"
```

The following script will then convert dependencies, tag, and reformat the data. This will create a new file in the
`$CONLL05` directory with the same name as the input and suffix `.parse.sdeps.combined`. 
If `$CONLL05` is not set, you should set it to the `conll05st-release` directory.
```bash
./bin/preprocess_conll05_sdeps.sh $CONLL05/train-set.gz
./bin/preprocess_conll05_sdeps.sh $CONLL05/dev-set.gz
./bin/preprocess_conll05_sdeps.sh $CONLL05/test.wsj.gz
./bin/preprocess_conll05_sdeps.sh $CONLL05/test.brown.gz
```

Now all that remains is to convert fields to BIO format. The following script will create a new file
in the same directory as the old file with the suffix `.bio`:
```bash
./bin/convert-bio.sh $CONLL05/train-set.gz.parse.sdeps.combined
./bin/convert-bio.sh $CONLL05/dev-set.gz.parse.sdeps.combined
./bin/convert-bio.sh $CONLL05/test.wsj.gz.parse.sdeps.combined
./bin/convert-bio.sh $CONLL05/test.brown.gz.parse.sdeps.combined
```

You may also want to generate a matrix of transition probabilities for performing Viterbi inference at test time. You
can use the following to do so:
```bash
python3 bin/compute_transition_probs.py --in_file_name $CONLL05/train-set.gz.parse.sdeps.combined.bio > $CONLL05/transition_probs.tsv
```

## Pre-processing for evaluation scripts

To evaluate using the CoNLL `eval.pl` and `srl-eval.pl` scripts, you'll need files in a different
format to evaluate against. To generate files for parse evaluation (`eval.pl`), use the following script:
```bash
python3 bin/eval/extract_conll_parse_file.py --input_file $CONLL05/dev-set.gz.parse.sdeps.combined --id_field 2 --word_field 3 --pos_field 4 --head_field 6 --label_field 7 > $CONLL05/conll2005-dev-gold-parse.txt
```

For SRL evaluation, use the following: 
```bash
python3 bin/eval/extract_conll_prop_file.py --input_file $CONLL05/dev-set.gz.parse.sdeps.combined --take_last --word_field 3 --pred_field 10 --first_prop_field 14 > $CONLL05/conll2005-dev-gold-props.txt
```