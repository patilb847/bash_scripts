#!/bin/bash
log_file="/home/bhushan/bash_scripts/PatchAudit/log/PatchAUdit$(date +"%d%m%Y%H%M%s").log"
log_dir=$(dirname $log_file)
if [ ! -d "$log_dir" ]
then
        $(mkdir -p "$log_dir")
fi

if [ ! $(command -v apt > /dev/null) ]
then
	update_cmd="apt"
	upgrade_list=$(apt list --upgradable 2>/dev/null | grep -v "Listing...")
elif [ ! $(command -v yum > /dev/null) ]
then
	update_cmd="yum"
	upgrade_list=$(yum check-update 2>/dev/null)
elif [ ! $(command -v dnf > /dev/null) ]
then
	update_cmd="dnf"
	upgrade_list=$(dnf check-update 2>/dev/null)
fi


if [ -n "$upgrade_list" ]
then

while IFS= read -r line; do
	if [ "$update_cmd" == "apt" ]
	then
		package=$(echo "$line" | awk -F "/" '{print $1}')
		package_repo=$(echo "$line" | awk -F " " '{print $1}' | awk -F "/" '{print $2}')
		available_package_version=$(echo "$line" | awk -F " " '{print $2}') 
		package_architecture=$(echo "$line" | awk -F " " '{print $3}')
		current_version=$(echo "$line" | awk -F "$package_architecture" '{print $2}')

	elif [ "$update_cmd" == "dnf" ] | [ "$update_cmd" == "yum" ]
	then
		package=$(echo "$line"| awk -F "." '{print $1}')
    		package_arch=$(echo "$line"| awk '{print $1}' | awk -F "." '{print $2}')
		available_package_version=$(echo "$line"|awk '{print $2}')
		package_repo=$(echo "$line"|awk '{print $3}')
		current_version=$(rpm -q "$package")
	fi
	echo "[ $(date) ]: Package: $package | Current: $current_version | Available: $available_package_version"| tee -a $log_file
done <<< $upgrade_list

fi
