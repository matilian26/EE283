#!/bin/bash
#$ -N align_reads
#$ -q class8-intel,bio,free64
#$ -pe make 8 
#$ -R y

#ls /bio/lillyl1/Classes/EE283/Bioinformatics_Course/scripts/test_F*.fq.qz | sed 's/.F.fq.gz//' > DNAseq.prefixes.txt
#num=$(wc -l DNAseq.prefixes.txt | cut -f1 -d ' ')

#$ -t 1

module load bwa/0.7.8
module load samtools/1.3
module load bcftools/1.3
module load enthought_python/7.3.2
module load gatk/2.4-7
module load picard-tools/1.87
module load java/1.7

ref="/bio/lillyl1/Classes/EE283/Bioinformatics_Course/ref/dm6.fa"

fullpathtoprefix=`head -n $SGE_TASK_ID DNAseq.prefixes.txt | tail -n 1`
prefix=$(basename $fullpathtoprefix)
folder="folder"
#folder=$(dirname $fullpathtoprefix | sed 's/od_rawdata/aligned_data/')
#readgroup=$(head -n 1 DNAseq.prefixes.txt | tail -n 1| cut -f8 -d '/')
readgroup=$prefix

bwa mem -t 8 -M $ref ${fullpathtoprefix}_F.fq.gz ${fullpathtoprefix}_R.fq.gz | samtools view -bS - > $folder/$SGE_TASK_ID.bam
samtools sort folder/$SGE_TASK_ID.bam -o $folder/$SGE_TASK_ID.sort.bam
java -Xmx20g -jar /data/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=$folder/$SGE_TASK_ID.sort.bam O=$folder/$SGE_TASK_ID.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$readgroup RGSM=$readgroup VALIDATION_STRINGENCY=LENIENT
samtools index $folder/$SGE_TASK_ID.RG.bam

