cron_lst=$1
log_file="/home/bhushan/bash_scripts/CronJobValidate/log/CronJobValidate$(date +"%d%m%Y%H%M%S").log"
log_dir=$(dirname $log_file)

if [ ! -d "$log_dir" ]
then
	mkdir $log_dir
fi

if [ -z "$cron_lst" ]
then

	echo "Usage $0 <cron file>"
	exit 1
fi
IFS=$'\n'
for cron_j in $(cat "$cron_lst")
do
	cron_user=$(echo $cron_j | cut -d "|" -f1)
	cron_job=$(echo $cron_j | cut -d "|" -f2)
	

	crontab -l -u $cron_user 2>/dev/null| grep -Fx "$cron_job" > /dev/null 2>&1
	
       	if [ $? = 1 ]
	then
		echo "[ $(date) ]: ALERT cron for $cron_user: $cron_job " | tee -a $log_file

	fi

done
