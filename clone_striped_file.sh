#!/usr/bin/env bash

input_file=$1

file_length=`awk 'END{ print NR}' $input_file`
column_count=`awk 'BEGIN {FS=","} { print NF }' $input_file`
# echo $input_file
echo $file_length
# echo $column_count
yy=`date "+%Y"`
mm=`date "+%b"`
dd=`date "+%d"`

new_file="DE_Flex_SubPub_"$dd$mm$yy.csv

# print only the specified columns
awk -F "," '{print $1","$2","$3","$5","$7","$11}' $input_file  >  $new_file

# Check is file has been created
[ ! -f $new_file ] && echo "The File Does not Exists" || echo "$new_file created!"

new_file_length=`awk 'END{ print NR}' $new_file`
echo $new_file_length

if [[ $file_length -eq $new_file_length ]]; then
    echo "ERROR: New File has LESS records!  "
fi
