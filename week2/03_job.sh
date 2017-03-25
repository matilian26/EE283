#!/bin/bash
#$ -q bio,abio,pub8i,free64

if [ -e myfilelines ]
then
    awk '$1<100' myfilelines > shortfiles.txt
else
    echo "Line Count file missing."
fi
