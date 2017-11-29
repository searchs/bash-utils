#!/bin/sh 

# Usage: ./s3puller.sh provider YYYY-MM-DD
provider=$1
data_date=$2
file=${provider}-${data_date}-extract.json.gz
bucket=multi-cash-migration
resource="/${bucket}/${file}" 
contentType="application/x-compressed-tar" 
dateValue="`date +'%a, %d %b %Y %H:%M:%S %z'`" 
stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}" 
s3Key=$ACCESS_KEY_ID
s3Secret=$SECRET_ACCESS_KEY 
signature=`/bin/echo -en "$stringToSign" | openssl sha1 -hmac ${s3Secret} -binary | base64` 
curl -H "Host: ${bucket}.s3.amazonaws.com" -H "Date: ${dateValue}" -H "Content-Type: ${contentType}" -H "Authorization: AWS ${s3Key}:${signature}" https://${bucket}.s3.amazonaws.com/${file}
