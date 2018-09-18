#!/usr/bin/env bash

conll05_data_url="http://www.lsi.upc.edu/~srlconll/conll05st-release.tar.gz"
conll05_scripts_url="http://www.lsi.upc.edu/~srlconll/srlconll-1.1.tgz"

wget $conll05_data_url
wget $conll05_scripts_url
tar xzvf conll05st-release.tar.gz
tar xzvf srlconll-1.1.tgz

rm conll05st-release.tar.gz
rm srlconll-1.1.tgz

export SRLCONLL="`pwd`/srlconll-1.1"
export CONLL05="`pwd`/conll05st-release"
export PERL5LIB=$SRLCONLL/lib:$PERL5LIB