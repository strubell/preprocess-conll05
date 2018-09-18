#! /bin/tcsh

# section for development  
set SECTIONS = "brown"

# name of the output file 
set FILE = "test.brown" 

foreach s ( $SECTIONS )

    echo Processing section $s

    zcat test.$s/words/test.$s.words.gz > /tmp/$$.words
    zcat test.$s/props/test.$s.props.gz > /tmp/$$.props

    ## Choose syntax
    # zcat devel/synt.col2/devel.$s.synt.col2.gz > /tmp/$$.synt
    # zcat devel/synt.col2h/devel.$s.synt.col2h.gz > /tmp/$$.synt
    # zcat devel/synt.upc/devel.$s.synt.upc.gz > /tmp/$$.synt
    # zcat devel/synt.cha/devel.$s.synt.cha.gz > /tmp/$$.synt

    # no gold parse, set to auto 
    zcat test.$s/synt.cha/test.$s.synt.cha.gz > /tmp/$$.synt

    # no senses, set to null
    zcat test.$s/null/test.$s.null.gz > /tmp/$$.senses
    zcat test.$s/ne/test.$s.ne.gz > /tmp/$$.ne

    paste -d ' ' /tmp/$$.words /tmp/$$.synt /tmp/$$.ne /tmp/$$.senses /tmp/$$.props | gzip> /tmp/$$.section.$s.gz
end

echo Generating gzipped file $FILE.gz
zcat /tmp/$$.section* | gzip -c > $FILE.gz

echo Cleaning files
rm -f /tmp/$$*

