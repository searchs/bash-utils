#! /bin/bash

# Monitor servers availability using a cron job

#TODO:  Email if service is less than 45%

seed_domain=$1

HOST=$seed_domain
check_count=0
expected_count=4

while [[ $check_count -lt $expected_count ]]; do
	echo $check_count
	ping -c 1 $HOST || echo "$HOST unreachable."
	check_count=$[$check_count+1]
	sleep 2
done

echo $check_count
status_level=$[$check_count/$expected_count*100]
echo $status_level
if [[ $status_level -eq 100 ]]; then
	echo "Service Level: EXCELLENT.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 80 ]]; then
	echo "Service Level: OK.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 60 ]]; then
	echo "Service Level: AVERAGE.  $HOST STATUS: $status_level%"
elif [[ $satus_level -lt 45 ]]; then
	echo "Service Level: DEGRADED. $HOST STATUS: $status_level%"
else
	echo "ERROR: Not sure server is running. Check domain. "

fi

if [[ $status_level -eq 100 ]]; then
	echo "ALERT! 0% Availability! Service is definitely DOWN.  Activate SLA Agreement. Call 0-NUMBER-OLA!"
fi

