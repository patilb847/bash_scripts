if [ -z "$1" ]
then
	echo "**ALERT mising commit message (./script <Message>)"
	exit 1
fi
git add .
git commit -m "$1"
git push origin main
