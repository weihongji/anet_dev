#! /bin/bash
#Example: $ bash checkout.sh ActiveNet18.3
if [ -z "$1" ]
then
	echo "No branch specified"
	exit
fi
read -p "Press [Enter] to switch to $1..."
echo


cd /d/git/acm
echo -e '\nSwitching acm...'
git checkout "$1"

#cd /d/git/activenet-clients

cd /d/git/activenet-flex
echo -e '\nSwitching activenet-flex...'
git checkout "$1"

cd /d/git/activenet-logs
echo -e '\nSwitching activenet-logs...'
git checkout "$1"

cd /d/git/activenet-package
echo -e '\nSwitching activenet-package...'
git checkout "$1"

cd /d/git/activenet-servlet
echo -e '\nSwitching activenet-servlet...'
git checkout "$1"

cd /d/git/activenet-sites
echo -e '\nSwitching activenet-sites...'
git checkout "$1"

cd /d/git/apd-interface-emv
echo -e '\nSwitching apd-interface-emv...'
git checkout "$1"

cd /d/git/aui
echo -e '\nSwitching aui...'
git checkout "$1"

#cd /d/git/cache-control
#cd /d/git/cert

cd /d/git/databases
echo -e '\nSwitching databases...'
git checkout "$1"

cd /d/git/db-schema
echo -e '\nSwitching db-schema...'
git checkout "$1"

cd /d/git/email-service
echo -e '\nSwitching email-service...'
git checkout "$1"

#cd /d/git/entry-point
#cd /d/git/entry-point-applet
#cd /d/git/entry-point-db
#cd /d/git/entry-point-ui

cd /d/git/pass-production
echo -e '\nSwitching pass-production...'
git checkout "$1"

cd /d/git/point-of-sale
echo -e '\nSwitching point-of-sale...'
git checkout "$1"

cd /d/git/rserver-ii
echo -e '\nSwitching rserver-ii...'
git checkout "$1"

#cd /d/git/sso
#cd /d/git/third-party-stuff

cd /d/git/utilities
echo -e '\nSwitching utilities...'
git checkout "$1"
