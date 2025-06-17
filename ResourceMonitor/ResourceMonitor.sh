log_file="/root/bash_scripts/ResourceMonitor/log/resource_monitor$(date +"%d%m%Y%H%M%S").log"
log_dir="/root/bash_scripts/ResourceMonitor/log/"

if [ ! -d "$log_dir" ]
then
	mkdir "$log_dir"
fi


cpu_cores=$(nproc)

check_cpu_usage(){
cores=$1

	cpu_usage=$(top -bn2 | grep "%Cpu" | tail -1 |awk '{print ""100-($8/'$cores')""}' )
	echo $cpu_usage
}

check_memory_usage(){
	memory_usage=$(free | head -2 | tail -1 | awk '{print ""($3/$2)*100""}')
	echo $memory_usage
}

check_load_average(){
	load_avg=$(cat /proc/loadavg | awk '{print $1}')
	echo $load_avg
}

cpu_usage=$(check_cpu_usage $cpu_cores)
memory_usage=$(check_memory_usage)
load_avg=$(check_load_average)

if (($(echo "${cpu_usage} > 80" | bc)))
then
	echo "ALERT High CPU Usage: $cpu_usage%" | tee -a $log_file
fi

if (( $(echo "${memory_usage} > 80" |bc) ))
then
	echo "ALERT High Memory Usage: $memory_usage%" | tee -a $log_file
fi

if (( $(echo "${load_avg} > ${cpu_cores}"|bc) ))
then
	echo "ALERT High Load Average/core: $load_avg%" | tee -a $log_file
fi



