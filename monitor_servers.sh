#! /bin/bash

# Monitor servers availability using a cron job

HOST=$1
check_count=0
expected_count=4

while [[ $check_count -lt $expected_count ]]; do
	ping -c 1 $HOST || echo "$HOST unreachable."
	check_count=$[$check_count+1]
	sleep 2
done

status_level=$[$check_count/$expected_count*100]
if [[ $status_level -eq 100 ]]; then
	echo "INFO: Service Level: EXCELLENT.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 80 ]]; then
	echo "INFO: Service Level: OK.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 60 ]]; then
	echo "INFO: Service Level: AVERAGE.  $HOST STATUS: $status_level%"
elif [[ $satus_level -lt 45 ]]; then
	echo "WARN: Service Level: DEGRADED. $HOST STATUS: $status_level%"
else
	echo "ERROR: Not sure server is running. Check domain. "

fi

# Test
if [[ $status_level -eq 100 ]]; then
	echo "ALERT! 0% Availability! Service is definitely DOWN.  Activate SLA Agreement. Call 0-NUMBER-OLA!"
	mail -s "$HOSt is down now!" email@domain.com <<< "ALERT! $HOST is down. "

fi

