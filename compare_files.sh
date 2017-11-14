#!/usr/bin/env bash

#####################################################################
#               Using Bash.  Not the PySpark solution               #
#       Compare old extracts and extracts from S3 (Kafka)           #
#       Accepts 2 files as inputs.                                  #
#       Legacy AC extract is the Primary file                       #
#                                                                   #
#####################################################################
set -e

# # Assuming jq is installed
# # Read with jq to break into multiple lines
# cat $source_$run_date.json | jq -c '.' > $source_$run_date_multilines.json 

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
     echo "-File size is the same.   Continue further check."
   else
    echo "$file_1 is $file1_size."
    echo "$file_2 is $file2_size."
    echo "ERROR:   File size does not match"
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
     echo "-File size is the same.   Continue further check."
   else
    echo "$file_1 has $file1_row_count."
    echo "$file_2 is $file2_row_count."
    echo "ERROR:   File row count does not match"
    exit 1
   fi
}


function get_md5_hash()
{
    filename=$1
    md5_hash=`md5 $filename`
    read -a arr <<< $md5_hash
    arr_length=$(echo ${#arr[@]})
    hash_value=$(echo ${arr[3]})
    echo $hash_value
}


function compare_hash()
{
    file_1=$1
    file_2=$2
   file1_hash=$(get_md5_hash "$file_1")
   file2_hash=$(get_md5_hash "$file_2")
   echo $file1_hash
   echo $file2_hash

if [ "$file1_hash" == "$file2_hash" ]                           
   then
     echo "-File hash is the same.  No further check required."
   else
    echo "$file_1 hash is $file1_hash."
    echo "$file_2 hash is $file2_hash."
    echo "ERROR:   File hash does not match"
    exit 1
   fi
}

# get the filenames without extensions
primary_name=$(echo $primary | cut -f 1 -d '.')
secondary_name=$(echo $secondary | cut -f 1 -d '.')
# check - remove after testing
echo $primary_name
echo $secondary_name

# SANITIZE FILES
# Assuming jq is installed. Read with jq to break into multiple lines
primary_multiline=${primary_name}_multilines.json
secondary_multiline=${secondary_name}_multilines.json

cat $primary | jq -c '.' > $primary_multiline
cat $secondary | jq -c '.' > $secondary_multiline

# generate a manifest for both files : file name, file size, record/row count
./manifest.sh $primary_multiline
./manifest.sh $secondary_multiline

# Sort files
echo "Sorting each file ......."

primary_sorted=${primary_name}_sorted.json
secondary_sorted=${secondary_name}_sorted.json

sort $primary_multiline > $primary_sorted
sort $secondary_multiline > $secondary_sorted

# exit 1

# Ensure both files only contain unique values
primary_unique=${primary_name}_unique.json
secondary_unique=${secondary_name}_unique.json

echo $primary_unique
echo $secondary_unique

echo "Extracting the unique values in the files only ...."
uniq $primary_sorted > $primary_unique 
uniq $secondary_sorted > $secondary_unique

# MD5 Hash values
echo "Generating md5 hash for each file"

compare_size $primary_unique $secondary_unique
compare_row_count $primary_unique $secondary_unique
compare_hash $primary_unique $secondary_unique

# md5 $primary_unique
# md5 $secondary_unique

# generate a manifest for both files with no dups : file name, file size, record/row count
./manifest.sh $primary_unique
./manifest.sh $secondary_unique

# SIMPLE DIFF - Suspend Diff
# diff $primary_unique $secondary_unique

# THE LONG ROUTE
# make the legacy file the primary file
# open the primary file for reading
# read each line and grep for string in the secondary file

# PENDING RESULTS

    # primary_file=$1
    # secondary_file=$2

    # while IFS= read -r line
    # do
    #     grep -x "$line" "$secondary_file"

    #     if [ $? -eq 0 ]; then
    #           echo "Missing in Kafka"
    #     fi
    # done <"$primary_file"

# if search string is found move to the next line
# if search string is not found add the search string(line) to external missing file
# generate manifest for missing records file
# verify reports
