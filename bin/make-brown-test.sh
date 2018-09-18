#! /bin/tcsh

# section for development  
set SECTIONS = "brown"

# name of the output file 
set FILE = "test.brown" 

foreach s ( $SECTIONS )

    echo Processing section $s

    zcat $CONLL05/test.$s/words/$FILE.words.gz > /tmp/$$.words
    zcat $CONLL05/test.$s/props/$FILE.props.gz > /tmp/$$.props

    # Use gold syntax
    zcat $CONLL05/$FILE/synt/$FILE.synt.gz > /tmp/$$.synt

    # no senses, set to null
    zcat $CONLL05/$FILE/null/$FILE.null.gz > /tmp/$$.senses
    zcat $CONLL05/$FILE/ne/$FILE.ne.gz > /tmp/$$.ne

    paste -d ' ' /tmp/$$.words /tmp/$$.synt /tmp/$$.ne /tmp/$$.senses /tmp/$$.props | gzip> /tmp/$$.section.$s.gz
end

echo Generating gzipped file $CONLL05/$FILE.gz
zcat /tmp/$$.section* | gzip -c > $CONLL05/$FILE.gz

echo Cleaning files
rm -f /tmp/$$*

