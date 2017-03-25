#!/bin/bash

FILES=/bio/lillyl1/EE283/Bioinformatics_Course/data/od_rawdata/*/DNAseq/*.fq.gz
for f in $FILES
do
    /bio/lillyl1/EE283/programs/seqtk/seqtk seq -Q64 -V $(readlink $f) | gzip -c > ${f%fq.gz}SANGER.fq.gz
done
