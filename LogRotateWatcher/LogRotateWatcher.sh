reset_flag=$1
log_file="/home/bhushan/bash_scripts/LogRotateWatcher/log/LogRotateWatcher$(date +"%d%m%Y%H%M%s").log"
log_dir=$(dirname $log_file)
compare_dir="/home/bhushan/bash_scripts/LogRotateWatcher/compare"
base_file="$compare_dir/basefile.txt"
current_file="$compare_dir/currentfile.txt"


log_rotate_conf="/etc/logrotate.conf"
log_rotate_dir="/etc/logrotate.d"



if [ ! -d "$log_dir" ]
then
        $(mkdir -p "$log_dir")
fi

if [ ! -d "$compare_dir" ]
then
        $(mkdir -p "$compare_dir")
fi

if [ -f "$current_file" ]
then
	rm -f "$current_file"
fi

if [ "$reset_flag" == "true" ]
then
        rm "$base_file"
fi

if [ ! -f "$base_file" ]
then
	echo "[ $(date) ]: this is first trigger or reset, base file will be created "
	sha256sum "$log_rotate_conf" >> "$base_file"

	for file in "$log_rotate_dir"/*
	do
		sha256sum "$file" >> "$base_file"

	done
	exit 0
fi

sha256sum "$log_rotate_conf" >> "$current_file"

for file in "$log_rotate_dir"/*
do
	sha256sum "$file" >> "$current_file"

done


if [ ! -f "$base_file" ]
then
	echo "[ $(date) ]: ALERT failed to create $base_file is missing"
	exit 1
fi

if [ ! -f "$current_file" ]
then
        echo "[ $(date) ]: ALERT failed to create $current_file is missing"
        exit 1
fi

diff_res=$(diff "$base_file" "$current_file")

while IFS= read -r line; do

	if [[ "$line" == \>* ]]
	then
		echo "[ $(date) ]: (ALERT) $(echo "$line" | awk '{print $NF}') is newly added or modified file" | tee -a $log_file
	elif [[ "$line" == \<* ]]
	then
		echo "[ $(date) ]: (ALERT) $(echo "$line" | awk '{print $NF}') file is deleted" | tee -a $log_file
	fi

done <<< "$diff_res"


