#! /bin/tcsh

# section for development  
set SECTIONS = "23"

# name of the output file 
set FILE = "test.wsj" 

foreach s ( $SECTIONS )

    echo Processing section $s

    zcat $CONLL05/$FILE/words/$FILE.words.gz > /tmp/$$.words
    zcat $CONLL05/$FILE/props/$FILE.props.gz > /tmp/$$.props
    zcat $CONLL05/$FILE/synt/$FILE.$s.synt.gz > /tmp/$$.synt

    # no senses, set to null
    zcat $CONLL05/$FILE/null/$FILE.null.gz > /tmp/$$.senses
    zcat $CONLL05/$FILE/ne/$FILE.ne.gz > /tmp/$$.ne

    paste -d ' ' /tmp/$$.words /tmp/$$.synt /tmp/$$.ne /tmp/$$.senses /tmp/$$.props | gzip> /tmp/$$.section.$s.gz
end

echo Generating gzipped file $CONLL05/$FILE.gz
zcat /tmp/$$.section* | gzip -c > $CONLL05/$FILE.gz

echo Cleaning files
rm -f /tmp/$$*

