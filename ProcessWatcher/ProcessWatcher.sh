process_lst=$1
log_file="/home/bhushan/bash_scripts/ProcessWatcher/log/ProcessAlert$(date +"%d%m%Y%H%M%S").log"
log_dir=$(dirname $log_file)

if [ ! -d "$log_dir" ]
then
	mkdir $log_dir
fi

if [ -z $process_lst ]
then

	echo "Usage $0 <process file>"
	exit 1
fi

for process in $(cat $process_lst)
do

	running_res=$(ps -ef | grep -w $process | grep -v grep)
	if [ -z "$running_res" ]
	then
		echo "[ $(date) ]: ALERT $process is not running" | tee -a $log_file
	fi

done
