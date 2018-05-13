#! /bin/bash

git_path=/d/git

cd $git_path/acm
echo -e '\nPulling acm...'
git pull

cd $git_path/activenet-clients
echo -e '\nPulling activenet-clients...'
git pull

cd $git_path/activenet-flex
echo -e '\nPulling activenet-flex...'
git pull

cd $git_path/activenet-logs
echo -e '\nPulling activenet-logs...'
git pull

cd $git_path/activenet-package
echo -e '\nPulling activenet-package...'
git pull

cd $git_path/activenet-servlet
echo -e '\nPulling activenet-servlet...'
git pull

cd $git_path/activenet-sites
echo -e '\nPulling activenet-sites...'
git pull

cd $git_path/apd-interface-emv
echo -e '\nPulling apd-interface-emv...'
git pull

cd $git_path/aui
echo -e '\nPulling aui...'
git pull

cd $git_path/cache-control
echo -e '\nPulling cache-control...'
git pull

cd $git_path/cert
echo -e '\nPulling cert...'
git pull

cd $git_path/databases
echo -e '\nPulling databases...'
git pull

cd $git_path/db-schema
echo -e '\nPulling db-schema...'
git pull

cd $git_path/email-service
echo -e '\nPulling email-service...'
git pull

cd $git_path/entry-point
echo -e '\nPulling entry-point...'
git pull

cd $git_path/entry-point-applet
echo -e '\nPulling entry-point-applet...'
git pull

cd $git_path/entry-point-db
echo -e '\nPulling entry-point-db...'
git pull

cd $git_path/entry-point-ui
echo -e '\nPulling entry-point-ui...'
git pull

cd $git_path/pass-production
echo -e '\nPulling pass-production...'
git pull

cd $git_path/point-of-sale
echo -e '\nPulling point-of-sale...'
git pull

cd $git_path/rserver-ii
echo -e '\nPulling rserver-ii...'
git pull

cd $git_path/sso
echo -e '\nPulling sso...'
git pull

cd $git_path/third-party-stuff
echo -e '\nPulling third-party-stuff...'
git pull

cd $git_path/utilities
echo -e '\nPulling utilities...'
git pull