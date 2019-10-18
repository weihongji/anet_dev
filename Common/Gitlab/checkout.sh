#! /bin/bash
#Example: $ bash checkout.sh ActiveNet18.3
if [ -z "$1" ]
then
	echo "No branch specified"
	exit
elif ! [[ $1 = ActiveNet* ]] #Only branch in pattern "ActiveNet*" is accepted.
then
	echo "Invalid branch \"$1\""
	exit
fi
read -p "Switching to $1. Press [Enter] to go..."
echo

git_path=/d/git

cd $git_path/acm
echo -e '\nSwitching acm...'
git checkout "$1"

#cd $git_path/activenet-clients

cd $git_path/activenet-flex
echo -e '\nSwitching activenet-flex...'
git checkout "$1"

cd $git_path/activenet-logs
echo -e '\nSwitching activenet-logs...'
git checkout "$1"

cd $git_path/activenet-package
echo -e '\nSwitching activenet-package...'
git checkout "$1"

# cd $git_path/activenet-servlet
# echo -e '\nSwitching activenet-servlet...'
# git checkout "$1"

cd $git_path/activenet-sites
echo -e '\nSwitching activenet-sites...'
git checkout "$1"

cd $git_path/apd-interface-emv
echo -e '\nSwitching apd-interface-emv...'
git checkout "$1"

cd $git_path/aui
echo -e '\nSwitching aui...'
git checkout "$1"

#cd $git_path/cache-control
#cd $git_path/cert

cd $git_path/databases
echo -e '\nSwitching databases...'
git checkout "$1"

cd $git_path/db-schema
echo -e '\nSwitching db-schema...'
git checkout "$1"

cd $git_path/email-service
echo -e '\nSwitching email-service...'
git checkout "$1"

#cd $git_path/entry-point
#cd $git_path/entry-point-applet
#cd $git_path/entry-point-db
#cd $git_path/entry-point-ui

cd $git_path/pass-production
echo -e '\nSwitching pass-production...'
git checkout "$1"

cd $git_path/point-of-sale
echo -e '\nSwitching point-of-sale...'
git checkout "$1"

cd $git_path/rserver-ii
echo -e '\nSwitching rserver-ii...'
git checkout "$1"

#cd $git_path/sso
#cd $git_path/third-party-stuff

cd $git_path/utilities
echo -e '\nSwitching utilities...'
git checkout "$1"
