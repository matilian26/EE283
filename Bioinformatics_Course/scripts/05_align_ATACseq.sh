#!/bin/bash
#$ -N align_ATACseq_reads
#$ -q bio,free64,abio
#$ -pe make 8 
#$ -R y

#ls /bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/A*/ATACseq/*F.fq.gz | sed 's/_F.fq.gz//' > ATACseq.prefixes.txt  # outside the array
#num=$(wc -l ATACseq.prefixes.txt | cut -f1 -d ' ')

#$ -t 19-21

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7

ref="/bio/lillyl1/Classes/EE283/Bioinformatics_Course/ref/dm6.fa"

fullpathtoprefix=`head -n $SGE_TASK_ID ATACseq.prefixes.txt | tail -n 1`
prefix=$(basename $fullpathtoprefix)
folder=$(dirname $fullpathtoprefix | sed 's/od_rawdata/aligned_data/')

mkdir -p $folder

bwa mem -t 4 -M $ref ${fullpathtoprefix}_F.fq.gz ${fullpathtoprefix}_R.fq.gz | samtools view -bS - > $folder/$prefix.bam
samtools sort $folder/$prefix.bam -o $folder/$prefix.sort.bam
samtools index $folder/$prefix.sort.bam
