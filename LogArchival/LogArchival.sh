target_dir=$1
archive_name="logs_backup_$(date +"%d%m%Y-%H%M%S").tar"
archive_dir="/root/bash_scripts/LogArchival/Archives"
log_file="/root/bash_scripts/LogArchival/Archives/logs_backup_$(date +"%d%m%Y").log"

if [ ! -d "$archive_dir" ]
then
        mkdir $archive_dir
fi

echo "">>$log_file
echo "#################Backup log for $target_dir###################"| tee -a $log_file
echo $(date) | tee -a $log_file
if [ ! -d $target_dir ]
then

	echo "[ $(date) ]: $target_dir does not exist."| tee -a $log_file

fi


file_lst=""

for file in $(echo "$(find $target_dir -type f -mtime +7)")
do
	files_lst+=" $(basename $file)"
done

files_lst="${files_lst:1}"

cd $target_dir

tar -cf $archive_name $files_lst


mv $archive_name $archive_dir

cd - >>/dev/null

echo "Following log files from $target_dir are added to archive $archive_name: $files_lst" | tee -a $log_file

