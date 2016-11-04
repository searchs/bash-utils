#! /usr/bin/env bash

# Monitor servers availability using a cron job

HOST=$1
check_count=0
expected_count=2

while [[ $check_count -lt $expected_count ]]; do
	ping -q -c 1 $HOST || echo -e "$HOST unreachable! "
	check_count=$[$check_count+1]
	sleep 3
done

status_level=$[$check_count/$expected_count*100]
if [[ $status_level -eq 100 ]]; then
	echo 
	echo -e "INFO: Service Level: EXCELLENT.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 80 ]]; then
	echo -e "INFO: Service Level: OK.  $HOST STATUS: $status_level%"
elif [[ $status_level -lt 60 ]]; then
	echo -e "INFO: Service Level: AVERAGE.  $HOST STATUS: $status_level% "
elif [[ $satus_level -lt 45 ]]; then
	echo -e "WARN: Service Level: DEGRADED. $HOST STATUS: $status_level% "
else
	echo -e "ERROR: Not sure server is running. Check domain. "

fi

# Test
if [[ $status_level -lt 20 ]]; then
	echo -e "ALERT! 0% Availability! Service is definitely DOWN.  Activate SLA Agreement. Call 0-NUMBER-OLA!"
	# mail -s "$HOSt is down now!" email@domain.com <<< "ALERT! $HOST is down. "  #SMTP setup needed on linux server

fi
