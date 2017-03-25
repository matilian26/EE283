#!/bin/bash
#$ -N Rsql_test
#$ -q bio,pub64,free64
#$ -m beas

module load R
R --no-save --quiet < Rsql_test.R
