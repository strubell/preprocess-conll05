#!/bin/bash

STANFORD_CP="$STANFORD_PARSER/*:$STANFORD_POS/*:"
postagger_model="$STANFORD_POS/models/english-left3words-distsim.tagger"

input_file=$1

# First, convert the constituencies from the files to the format expected by the converter
echo "Extracting trees from: $input_file"
# word pos parse -> stick words, pos into parse as terminals
# gsub(/#/, "$", $1); gsub(/#/, "$", $2);
zcat $input_file | \
awk '{gsub(/\(/, "-LRB-", $1); gsub(/\)/, "-RRB-", $1); gsub(/\(/, "-LRB-", $2); gsub(/\)/, "-RRB-", $2); print $2" "$1"\t"$3}' | \
sed 's/\(.*\)\t\(.*\)\*\(.*\)/\2(\1)\3/' > "$input_file.parse"

# Now convert those parses to dependencies
# Output will have the extension .dep
echo "Converting to dependencies: $input_file.parse"
java -Xmx8g -cp $STANFORD_CP edu.stanford.nlp.trees.EnglishGrammaticalStructure \
    -treeFile "$input_file.parse" -basic -conllx -keepPunct -makeCopulaHead > "$input_file.parse.sdeps"

# Now assign auto part-of-speech tags
# Output will have extension .tagged
echo "POS tagging: $input_file.parse.sdeps"

# need to convert to text format Stanford likes
awk '{if(NF){printf "%s ", $2} else{ print "" }}' "$input_file.parse.sdeps" > "$input_file.parse.sdeps.posonly"

java -Xmx8g -cp $STANFORD_CP edu.stanford.nlp.tagger.maxent.MaxentTagger \
    -model $postagger_model \
    -textFile "$input_file.parse.sdeps.posonly" \
    -tokenize false \
    -outputFormat tsv \
    -sentenceDelimiter newline \
    > "$input_file.parse.sdeps.pos"

echo "Combining: $input_file.parse.sdeps, $input_file.parse.sdeps.pos"

# Finally, paste the original file together with the dependency parses and auto pos tags
f_converted="$input_file.parse.sdeps"
f_pos="$input_file.parse.sdeps.pos"
f_combined="$f_converted.combined"

# docid is conll05
paste <(zcat $input_file | awk 'BEGIN{s=0;c=0}{if(NF == 0){print ""; c=0; s++} else {print "conll05\t"s"\t"c++"\t"$1}}' ) \
    <(awk '{print $5}' $f_converted) \
    <(awk '{print $2}' $f_pos) \
    <(awk '{if(NF == 0){print ""} else {print $7"\t"$8"\t_"}}' $f_converted) \
    <(zcat $input_file | awk '{if(NF == 0){print ""} else {print $5"\t"$6"\t-\t-\t"$4}}' ) \
    <(zcat $input_file | awk '{if(NF == 0){print ""} else {print $0}}' | tr -s ' ' | cut -d' ' -f7- | sed 's/ /\t/g') \
> $f_combined
