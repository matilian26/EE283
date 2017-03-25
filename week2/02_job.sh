#1/bin/bash
#$ -q bio,abio,pub8i,free64

if [ -e file_list.txt ]
then
    for line in $(cat file_list.txt)
    do
        wc -l $line
    done > myfilelines
    # parallel --jobs $CORES wc -l {} ::::file_list
else
    echo "My file list does not exist."
fi 
