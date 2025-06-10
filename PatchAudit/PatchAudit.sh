#!/bin/bash
log_file="/home/bhushan/bash_scripts/PatchAudit/log/PatchAUdit$(date +"%d%m%Y%H%M%s").log"
log_dir=$(dirname $log_file)
if [ ! -d "$log_dir" ]
then
        $(mkdir -p "$log_dir")
fi

command -v apt > /dev/null
apt_check="false"
if [ $? -eq 0 ]
then
	apt_check="true"
	upgrade_list=$(apt list --upgradable)
fi

if [ -n "$upgrade_list" ]
then

while IFS= read -r line; do
	package=$(echo "$line" | awk -F "/" '{print $1}')
	package_repo=$(echo "$line" | awk -F " " '{print $1}' | awk -F "/" '{print $2}')
	available_package_version=$(echo "$line" | awk -F " " '{print $2}') 
	package_architecture=$(echo "$line" | awk -F " " '{print $3}')
	current_version=$(echo "$line" | awk -F "$package_architecture" '{print $2}')

	echo "[ $(date) ]: Package $package can be updated from $current_version to $available_package_version"| tee -a $log_file

done <<< $upgrade_list

fi
