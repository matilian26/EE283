#!/bin/bash
#$ -q bio,abio,free64,pub64

qsub -N listfiles 01_job.sh
qsub -N linecount -hold_jid listfiles 02_job.sh
qsub -N shortfiles -hold_jid linecount 03_job.sh
