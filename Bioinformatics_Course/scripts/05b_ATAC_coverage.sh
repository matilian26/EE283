#!/bin/bash
#$ -N ATAC_coverage
#$ -q abio,bio,free64
#$ -pe make 8 
#$ -R y

#ls /bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/A*/ATACseq/*F.fq.gz | sed 's/_F.fq.gz//' > ATACseq.prefixes.txt  # outside the array
#num=$(wc -l ATACseq.prefixes.txt | cut -f1 -d ' ')

#$ -t 1-24

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7
module load bedtools/2.25.0
#module load jje/kent/2014.02.19

ref="/bio/lillyl1/Classes/EE283/Bioinformatics_Course/ref/dm6.fa"

fullpathtoprefix=`head -n $SGE_TASK_ID ATACseq.prefixes.txt | tail -n 1`
prefix=$(basename $fullpathtoprefix)
source_folder=$(dirname $fullpathtoprefix | sed 's/od_rawdata/aligned_data/')
dest_folder=$(dirname $fullpathtoprefix | sed 's/od_rawdata/analyzed_data/')

mkdir -p $dest_folder

# normalize across samples
Nreads=`samtools view -c -F 4 $source_folder/$prefix.sort.bam`
Scale=`echo "1.0/($Nreads/1000000)" | bc -l`
samtools view -b $source_folder/$prefix.sort.bam | genomeCoverageBed -ibam - -g $ref -bg -scale $Scale > $dest_folder/$prefix.coverage
