reset_flag=$1
paths_file="/home/bhushan/bash_scripts/FileIntegrityMonitoring/config/moitor_paths.txt"
log_file="/home/bhushan/bash_scripts/FileIntegrityMonitoring/logs/FileIntegrityMonitoring$(date +"%d%m%Y").log"
log_dir=$(dirname $log_file)
compare_dir="/home/bhushan/bash_scripts/FileIntegrityMonitoring/compare"
base_file="$compare_dir/basefile.txt"
current_file="$compare_dir/current.txt"

if [ ! -d "$log_dir" ]
then
        mkdir -p "$log_dir"
fi

if [ ! -d "$compare_dir" ]
then
        mkdir -p "$compare_dir"
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
	#sha256sum "$log_rotate_conf" >> "$base_file"

	#for file in "$log_rotate_dir"/*
	#do
	#	sha256sum "$file" >> "$base_file"
	#done

	while IFS= read -r line;do

		if [ -d "$line" ]
		then
			find $line -type f -exec sha256sum {} \; >> "$base_file"
		elif [ -f "$line" ]
		then
			sha256sum "$line" >> "$base_file"
		else
			echo "[ $(date) ]: $line does not exist , no file or directory"
		fi

	done < "$paths_file"


	exit 0
fi


while IFS= read -r line;do

	if [ -d "$line" ]
        then
              	find $line -type f -exec sha256sum {} \; >> "$current_file"
      	elif [ -f "$line" ]
        then
                sha256sum "$line" >> "$current_file"
        else
                echo "[ $(date) ]: $line does not exist , no file or directory" | tee -a $log_file
        fi

done < "$paths_file"

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


diff_res=$(diff $base_file $current_file)

while IFS= read -r line;do

	if [[ "$line" == \>* ]]
	then
		echo "[ $(date) ]: (ALERT) $(echo "$line" | awk '{print $NF}') is  modified file" | tee -a $log_file
	fi


done <<< "$diff_res"


