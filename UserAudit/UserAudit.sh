user_file="/home/bhushan/bash_scripts/UserAudit/users.txt"
log_file="/home/bhushan/bash_scripts/UserAudit/log/UserAudit$(date +"%d%m%Y%H%M%s").log"
log_dir=$(dirname $log_file)

if [ ! -d "$log_dir" ]
then
        $(mkdir $log_dir)
fi

if [ ! -f "$user_file" ]
then
        echo "[ $(date) ] : services file not found at $user_file [ALERT]" | tee -a $log_file
        exit 1
fi

for user in $(cat $user_file | tr -s "\n")
do

	id $user >&/dev/null
	if [ $? = 0 ]
	then
		user_state=$(passwd -S $user)
		
		if [ "$(echo "$user_state" | cut -d " " -f2)" == "L" ]
		then
			echo "[ $(date) ]: user $user exists and is in locked state ($user_state)" | tee -a $log_file
		elif [ "$(echo "$user_state" | cut -d " " -f2)" == "P" ] 
		then
			echo "[ $(date) ]: user $user exists and is in active state ($user_state)" | tee -a $log_file

		elif [ "$(echo "$user_state" | cut -d " " -f2)" == "NP" ]
                then
                        echo "[ $(date) ]: user $user exists but has no password set ($user_state)" | tee -a $log_file
		
		else
			echo "[ $(date) ]: user $user is in unknown state ($user_state)" | tee -a $log_file

		fi
	else
		echo "[ $(date) ]: user $user does not exist" | tee -a $log_file
	fi
done
