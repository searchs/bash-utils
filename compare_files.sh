#!/usr/bin/env bash

#####################################################################
#                                                                   #
#       Compare Legacy extracts and extracts from S3 (Kafka)        #
#       Accepts 2 files as inputs.                                  #
#       Legacy AC extract is the Primary file                       #
#                                                                   #
#####################################################################
set -e
# Need to install parallel

# jq: with -c option breaks file content into multiple lines
# parallel: allow for parallel sorting without maxed-memory
# pv: monitor progress of job 

data_date=`date +%Y%m%d -d yesterday`
echo $data_date

primary=$1
secondary=$2

function compare_size()
{
   file_1=$1
   file_2=$2

   file1_size=`wc -c $file_1 | awk '{print $1}'`
   file2_size=`wc -c $file_2 | awk '{print $1}'`
    if [ $file1_size -eq $file2_size ]                           
   then
     echo "SUCCESS: File size is the same.   Continue further check."

   else
    echo "$file_1 is ${file1_size}."
    echo "$file_2 is $file2_size."
    echo "ERROR:   File size does not match"
    # call python script to run checks and spit out the difference into a csv
    # ./extractor_compare.py $file_1 $file_2 #to uncomment once validation is complete
    exit 1
   fi
}

function compare_row_count()
{
    file_1=$1
    file_2=$2

    file1_row_count=`wc -l $file_1 | awk '{print $1}'`
    file2_row_count=`wc -l $file_2 | awk '{print $1}'`
    if [ $file1_row_count -eq $file2_row_count ]                           
   then
     echo "SUCCESS: File row count is the same.  Continue further check."

   else
    echo "$file_1 has $file1_row_count."
    echo "$file_2 is $file2_row_count."
    echo "ERROR:   File row count does not match"
    # call python script to run checks and spit out the difference into a csv
    # ./extractor_compare.py $file_1 $file_2 #to uncomment once validation is complete
    exit 1
   fi
}

function get_md5_hash()
{
    filename=$1
    md5_hash=`md5sum <<< $filename`
    read -a arr <<< $md5_hash
    hash_value=$(echo ${arr[0]})
    echo $hash_value
}

function compare_hash()
{
    file_1=$1
    file_2=$2
    file1_hash=`get_md5_hash "$file_1"`
    file2_hash=`get_md5_hash "$file_2"`

    echo $file1_hash
    echo $file2_hash

if [ "$file1_hash" == "$file2_hash" ]                           
   then
     echo "-File hash is the same.  No further check required."

   else
    echo "$file_1 hash is $file1_hash."
    echo "$file_2 hash is $file2_hash."
    echo "ERROR:   File hash does not match"
    # call python script to run checks and spit out the difference into a csv
    # ./extractor_compare.py $file_1 $file_2 #to uncomment once validation is complete
    exit 1
   fi
}

function quicksort(){
  usage() {

    echo "Parallel sort"
    echo "usage: psort file1 file2"
    echo "Sorts text file file1 and stores the output in file2"
}

parallel --citation

# test if we have two arguments on the command line
if [ $# != 2 ]
then
    usage
    exit
fi

pv $1 | parallel --pipe --files sort -S512M | parallel -Xj1 sort -S1024M -m {} ';' rm {} > $2

}


get_md5_hash $1
get_md5_hash $2

# get the filenames without extensions
primary_name=$(echo $primary | cut -f 1 -d '.')
secondary_name=$(echo $secondary | cut -f 1 -d '.')

# SANITIZE FILES
primary_multiline=${primary_name}_multilines.txt
secondary_multiline=${secondary_name}_multilines.txt


# works
# Primary
cat -AE $primary | tr -d '^' > clean_primary.json
perl -pi -w -e 's/}M{/}\n{/g;' clean_primary.json 
mv clean_primary.json $primary_multiline
 
# Secondary
cat -AE $secondary | tr -d '^' > clean_secondary.json
perl -pi -w -e 's/}M{/}\n{/g;' clean_secondary.json 
mv clean_secondary.json $secondary_multiline
ls -laSh

# jq -c '.'< $primary > $primary_multiline
# jq -c '.'< $secondary > $secondary_multiline

echo "line count after breaking into multilines ..."
wc -l $primary_multiline
wc -l $secondary_multiline

# Sort files
echo "Preparing filenames for sorting ......."
primary_sorted=sorted_${primary_name}.txt
secondary_sorted=sorted_${secondary_name}.txt

echo "Sorting Primary file now"
quicksort $primary_multiline $primary_sorted

echo "Sorting Secondary file now "
quicksort $secondary_multiline $secondary_sorted

# Ensure both files only contain unique values
primary_unique=${primary_name}_unique.txt
secondary_unique=${secondary_name}_unique.txt

# Uniq options: 
echo "Extracting the unique values in the files ...."
uniq $primary_sorted > $primary_unique 
uniq $secondary_sorted > $secondary_unique

if [ -z "$primary_sorted" ];

echo "Unique files now generated ...."

# MD5 Hash values
echo "Printing Hash values for both files.  Primary first ................"
md5sum <<< $primary_unique
md5sum <<< $secondary_unique

compare_size $primary_unique $secondary_unique
compare_row_count $primary_unique $secondary_unique
compare_hash $primary_unique $secondary_unique



# generate a manifest for both files with no dups : file name, file size, record/row count
./manifest.sh $primary_unique
./manifest.sh $secondary_unique

# Cleanup Process
# rm *_multilines*
# rm sorted_*
# rm $primary_*git log

# rm $secondary_*

echo "End of processing."
echo "EXIT STATUS: $?.  0 means success!"
