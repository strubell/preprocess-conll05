#!/bin/bash
#
# Converts the fields defined below in the given file (arg1) to BIO format from the CoNLL-2005/2012 format.
#

input_file=$1

bilou_arg="--bio"

max_field=`awk '{print NF}' $input_file | sort -n | tail -1`
first_field=14
fields_to_convert=`seq $first_field $(( max_field ))`

tmpfile=`mktemp`

bilou_file="$input_file.bio"
cp $input_file $bilou_file

for field in $fields_to_convert; do
    echo "Converting field $field of $(( max_field ))"
    echo "bin/convert-bilou-single-field.py --input_file $bilou_file --field $((field - 1)) --take_last $bilou_arg"
    python3 bin/convert-bilou-single-field.py --input_file $bilou_file --field $((field - 1)) --take_last $bilou_arg > $tmpfile
    cp $tmpfile $bilou_file
done

rm $tmpfile

