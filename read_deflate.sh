#! /bin/bash -e

#  Read HDFS files using BASH

INDIRECTORY="/location/output/20161025"
for f in $INDIRECTORY/000000_0; do
    echo "Processing $f file..";
    cat -v $f |
        LC_ALL=C sed -e "s/^/\"/g" |
        LC_ALL=C sed -e "s/\^A/\",\"/g" |
        LC_ALL=C sed -e "s/\^C\^B/\"\":\"\"\"\",\"\"/g" |
        LC_ALL=C sed -e "s/\^B/\"\",\"\"/g" |
        LC_ALL=C sed -e "s/\^C/\"\":\"\"/g" |
        LC_ALL=C sed -e "s/$/\"/g" > $f
done
# echo "col_1,you,can,echo,your,header,here,if,you,like,col_30" > $INDIRECTORY/final_output.csv
cat $INDIRECTORY/* >> $INDIRECTORY/final_output.csv
# rm $INDIRECTORY/*
