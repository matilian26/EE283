import os
import subprocess
import re

# Create a dictionary that maps number to the stand of the read
strand = {}
strand['1'] = 'F'
strand['2'] = 'R'

# ATACseq data
# Create dictionary mapping ATACseq Barcodes to Experimental Samples
ATACmap = {}
regex = re.compile('(P\d+)\s+(A\d)\s+(\wD)\s+(\d)')
with open('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/rawdata/ATACseq/README.ATACseq.txt') as f:
    for line in f:
        m = regex.search(line)
        # m.group(1) = barcode
        # m.group(2) = genotype
        # m.group(3) = tissue
        # m.group(4) = biological replicate
        if m:
            ATACmap[m.group(1)] = '%s_%s_Rep%s' %(m.group(2),m.group(3),m.group(4))

# Get files in folder and create symlinks with names based on ATACseq mapping dictionary
_,_,filenames = next(os.walk('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/rawdata/ATACseq'),(None, None, []))
regex = re.compile('Sample_[\w]+-[\w]+_4R009_L1_([\w\d]+)_R(\d).fq.gz')

for file in filenames:
    if file.endswith('fq.gz'):
        m = regex.search(file)
        # m.group(1) = barcode
        # m.group(2) = dtrand
        if not os.path.exists('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s' %ATACmap[m.group(1)][0:2]):
            os.mkdir('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s' %ATACmap[m.group(1)][0:2])
	if not os.path.exists('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/ATACseq' %ATACmap[m.group(1)][0:2]):
            os.mkdir('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/ATACseq' %ATACmap[m.group(1)][0:2])
        subprocess.call(['ln', '-s', '/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/rawdata/ATACseq/%s' %file, '/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/ATACseq/%s_%s.fq.gz' %(ATACmap[m.group(1)][0:2],ATACmap[m.group(1)],strand[m.group(2)])])

# DNAseq data
DNAmap = dict(zip(['ADL06','ADL09','ADL10','ADL14'],['A4','A5','A6','A7']))

# Get files in folder and create symlinks with names based on ATACseq mapping dictionary
_,_,filenames = next(os.walk('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/rawdata/DNAseq'),(None, None, []))
regex = re.compile('(ADL\d+)_(\d)_(\d)')

for file in filenames:
    if file.endswith('fq.gz'):
        m = regex.search(file)
        # m.group(1) = barcode
        # m.group(2) = replicate lane
        # m.group(3) = strand
        if not os.path.exists('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s' %DNAmap[m.group(1)]):
            os.mkdir('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s' %DNAmap[m.group(1)])
        if not os.path.exists('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/DNAseq' %DNAmap[m.group(1)]):
            os.mkdir('/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/DNAseq' %DNAmap[m.group(1)])
        subprocess.call(['ln', '-s', '/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/rawdata/DNAseq/%s' %file, '/bio/lillyl1/Classes/EE283/Bioinformatics_Course/data/od_rawdata/%s/DNAseq/%s_Rep%s_%s.fq.gz' %(DNAmap[m.group(1)],DNAmap[m.group(1)],m.group(2),strand[m.group(3)])])
