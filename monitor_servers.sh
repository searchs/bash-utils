#! /bin/bash

#  author:  Ola Ajibode

# Monitor servers availability using a cron job
#  Run script: ./monitor_servers.sh "ohprice.com"

seed_domain=$1

HOST=$seed_domain
check_count=0
expected_count=10

while [[ $check_count -lt $expected_count ]]; do
	echo $check_count
	ping -c 1 $HOST || echo "$HOST unreachable."
	check_count=$[$check_count+1]
	sleep 300 
done

echo $check_count
status_level=($check_count/$expected_count*100)
echo $status_level
if [[ $status_level -eq 100 ]]; then
	#statements
	echo "Excellent.  $HOST is up 100%"
elif [[ $status_level -lt 80 ]]; then
	#statements
	echo "Service is OK.  About 80% availability"

fi

