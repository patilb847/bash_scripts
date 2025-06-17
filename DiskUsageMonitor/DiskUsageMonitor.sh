threshold=$1
log_file="$(pwd)/log/DiskMonitor$(date +"%d%m%Y%H%M%S").log"
log_dir="$(pwd)/log/"

if [ ! -d "$log_dir" ]
then
	mkdir $log_dir
fi

if [ -z "$threshold" ]
then
	echo "Usage $0 <threshold_value>"
	exit 1
fi


for dsk in $(echo "$(df -Ph |tail -n +2| awk '{print $1 "##" $5}')");
do
	per_no=$(echo $dsk | awk -F "##" '{print $2}')
	dsk_p=$(echo $dsk | awk -F "##" '{print $1}')
	
	if [ $(echo $per_no | cut -d "%" -f1) -gt $threshold ]
	then
		echo "[ $(date) ]: Alert $dsk_p is $per_no full (threshold=$threshold)" | tee -a $log_file
	fi

done

