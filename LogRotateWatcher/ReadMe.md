*Usage

		This script monitors changes to /etc/logrotate.conf and all files under /etc/logrotate.d/.

		On the first run, it creates a baseline hash file of the monitored files.

		On every subsequent run, it generates a new hash file and compares it against the baseline using diff.

		A log is generated only when a file is added, removed, or modified.

		To reset the baseline hash file manually, run the script with the argument true:
