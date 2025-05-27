services_file="/root/bash_scripts/ServiceMonitor/services.txt"
log_file="/root/bash_scripts/ServiceMonitor/logs/ServicesLog$(date +"%d%m%Y").log"
log_dir=$(dirname $log_file)

if [ ! -d "$log_dir" ]
then
	$(mkdir $log_dir)
fi

if [ ! -f "$services_file" ]
then
	echo "[ $(date) ] : services file not found at $services_file [ALERT]" | tee -a $log_file
	exit 1
fi

for service in $(cat $services_file | grep -v "^#" | tr -s "\n")
do
	service_status=$(systemctl status $service | grep -i 'Active: active (running)\|Active: inactive\|service could not be found')

	if [ -z "$service_status" ]
	then
		echo "[ $(date) ] : service $service does not exist [ALERT]" | tee -a $log_file
	elif [ -n "$(echo "$service_status" | grep "Active: active (running)")" ]
	then
		echo "[ $(date) ] : $service is active"
	elif [ -n "$(echo "$service_status" | grep "Active: inactive")" ]
	then
		echo "[ $(date) ] : $service is inactive! [ALERT]" | tee -a $log_file
	fi

	

done

