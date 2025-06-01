threshold=$1
log_file="/home/bhushan/bash_scripts/DiskUsageMonitor/log/DiskMonitor$(date +"%d%m%Y%H%M%S").log"
log_dir="/home/bhushan/bash_scripts/DiskUsageMonitor/log/"

if [ ! -d "$log_dir" ]
then
	mkdir $log_dir
fi

if [ -z "$threshold" ]
then
	echo "Usage $0 <threshold_value>"
	exit 1
fi

#res=$(df -Ph | tail -n +2 |awk '{if ($5>'$threshold'){print "[ '$(date +"%d-%m-%Y")' '$(date +"%H:%M:%S")' ]: ALERT "$1" is "$5" full"}}') 

#if [ -n "$res" ]
#then
#	echo "$res"
#fi

for dsk in $(echo "$(df -Ph |tail -n +2| awk '{print $1 "##" $5}')");
do
	per_no=$(echo $dsk | awk -F "##" '{print $2}')
	dsk_p=$(echo $dsk | awk -F "##" '{print $1}')
	
	if [ $(echo $per_no | cut -d "%" -f1) -gt $threshold ]
	then
		echo "[ $(date) ]: Alert $dsk_p is $per_no full (threshold=$threshold)" | tee -a $log_file
	fi

done

