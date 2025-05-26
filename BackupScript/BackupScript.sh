dir_path=$1
parent_dir=$(dirname $dir_path)
dir_name=$(basename $dir_path)
date=$(date +"%Y%m%d-%H%M")
file_name="backup-${dir_name}-${date}.tar.gz"
log_file="/root/bash_scripts/BackupScript/logs/backup_log$(date +"%Y%m%d").log"


if [ ! -d $(dirname $log_file) ]
then
	mkdir $(dirname $log_file)
fi

if [ ! -d "$dir_path" ]
then	
	echo "[ $(date) ] : Folder $dir_path does not exist" | tee -a $log_file
	exit
fi

cd $(dirname $dir_path)
tar -cf "$file_name" $dir_name
cd -

if [ -f "${parent_dir}/${file_name}" ]
then
	echo "[ $(date) ] : backup of ${dir_path} successfully taken at ${parent_dir}/${file_name}" | tee -a $log_file
else
	echo "[ $(date) ] : failed to take backup of ${dir_path}"
fi


