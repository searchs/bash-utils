#!/usr/bin/env bash

if [ -z "$1" ]
  then
    echo "No file supplied."
    echo 'Usage: '
    echo
    echo './breaklines.sh fileToBreak'
    echo 
    
    exit 1
fi

dataFile=$1

# use filename/extension extractor in compare.sh
file_name=$(echo $dataFile | cut -f 1 -d '.')

function getFileName()
{
  fullfilename=$1
  filename=$(basename "$fullfilename")
  fname="${filename%.*}"
  echo $fname
 
}

function getFileExtension()
{
  fullfilename=$1
  filename=$(basename "$fullfilename")
  ext="${filename##*.}"
  echo $ext
}

filename=`getFileName ${dataFile}`
file_ext=`getFileExtension ${dataFile}`

cat -AE $dataFile | tr -d '^' > clean_data.${file_ext}
perl -pi -e 's/}M{/}\n{/g;' clean_data.${file_ext}  

readyFile=${filename}_multilines.${file_ext}

mv clean_data.${file_ext} $readyFile
sleep 2
