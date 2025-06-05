*Usage

	-this script monitors logrotate.conf and all files inside logrotate.d directory.
	-on first run script creates base file which contains hash values for all logrotate files, for every run after that new file with hash values will be generated and compared against basefile with diff command.
	-log will be generated only if any new logrotate file is added/modified or removed.
	-for starting script with new base file run ./LogRotateWatcher.sh <true>.
