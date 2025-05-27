log_file="/root/bash_scripts/SystemMonitor/logs/SystemLog$(date +"%d%m%Y").log"
log_dir=$(dirname $log_file)

if [ ! -d "$log_dir" ]
then
	$(mkdir $log_dir)
fi

echo "*********************************************************************" | tee -a $log_file
echo $(date)  | tee -a $log_file
echo "*********************************************************************"  | tee -a $log_file
echo "===============================uptime================================" | tee -a $log_file
echo "" | tee -a $log_file
echo "$(uptime)" | tee -a $log_file
echo "" | tee -a $log_file
echo "=========================CPU and Memory Usage========================" | tee -a $log_file
echo "" | tee -a $log_file
echo "$(top -b -n1 | head -5)" | tee -a $log_file
echo "" | tee -a $log_file
echo "=============================Disk Usage==============================" | tee -a $log_file
echo "" | tee -a $log_file
echo "$(df -h)" | tee -a $log_file
echo "" | tee -a $log_file
echo "=====================================================================" | tee -a $log_file
echo "" | tee -a $log_file
