#! /bin/tcsh

# section for development  
set SECTIONS = "24"

# name of the output file 
set FILE = "dev-set" 

foreach s ( $SECTIONS )

    echo Processing section $s

    zcat $CONLL05/devel/words/devel.$s.words.gz > /tmp/$$.words
    zcat $CONLL05/devel/props/devel.$s.props.gz > /tmp/$$.props

    ## Choose syntax
    # zcat devel/synt.col2/devel.$s.synt.col2.gz > /tmp/$$.synt
    # zcat devel/synt.col2h/devel.$s.synt.col2h.gz > /tmp/$$.synt
    # zcat devel/synt.upc/devel.$s.synt.upc.gz > /tmp/$$.synt
    # zcat devel/synt.cha/devel.$s.synt.cha.gz > /tmp/$$.synt

    # Use gold syntax
    zcat $CONLL05/devel/synt/devel.$s.synt.wsj.gz > /tmp/$$.synt

    zcat $CONLL05/devel/senses/devel.$s.senses.gz > /tmp/$$.senses
    zcat $CONLL05/devel/ne/devel.$s.ne.gz > /tmp/$$.ne

    paste -d ' ' /tmp/$$.words /tmp/$$.synt /tmp/$$.ne /tmp/$$.senses /tmp/$$.props | gzip> /tmp/$$.section.$s.gz
end

echo Generating gzipped file $CONLL05/$FILE.gz
zcat /tmp/$$.section* | gzip -c > $CONLL05/$FILE.gz

echo Cleaning files
rm -f /tmp/$$*

