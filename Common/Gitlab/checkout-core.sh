#! /bin/bash
#Example: $ bash checkout-core.sh ActiveNet19.12

# Parameters
branch=""
if [ -z "$1" ]
then
	echo "No branch specified"
	exit
elif [[ $1 =~ ^[1-9][0-9].[0-9]{2}$ ]]; then
	branch="ActiveNet$1"
else
	branch=$1
fi

if ! [[ $branch = ActiveNet* ]] #Only branch in pattern "ActiveNet*" is accepted.
then
	echo -e "Invalid branch \"$1\""
	exit
fi
read -p "Switching to $1. Press [Enter] to go..."
echo

do_pull="n"
if [ "$2" = "pull" -o "$3" = "pull" -o "$4" = "pull" ]
then
	do_pull="y"
fi

if [ $do_pull = "y" ]
then
	bash pull.sh
fi

do_stash="y"
if [ "$2" = "no-stash" -o "$3" = "no-stash" -o "$4" = "no-stash" ]
then
	do_stash="n"
fi

apply_stash="y"

if [ $do_stash = "n" ]; then
	apply_stash="n"
fi

if [ "$2" = "no-apply" -o "$3" = "no-apply" -o "$4" = "no-apply" ]
then
	apply_stash="n"
fi

if [ "$2" = "apply-stash" -o "$3" = "apply-stash" -o "$4" = "apply-stash" ]
then
	apply_stash="y"
fi

# Switch branch
git_path=/c/Users/jwei/git

cd $git_path/acm
if [ $do_stash = "y" ]; then
	echo -e '\nStashing acm...'
	git stash
fi
echo -e '\nSwitching acm...'
git checkout "$branch"
if [ $apply_stash = "y" ]; then
	echo -e '\nApplying stash acm...'
	git stash apply
fi

cd $git_path/activenet-cui
echo -e '\nSwitching activenet-cui...'
git checkout "$branch"

cd $git_path/activenet-flex
echo -e '\nSwitching activenet-flex...'
git checkout "$branch"

cd $git_path/activenet-logs
echo -e '\nSwitching activenet-logs...'
git checkout "$branch"

cd $git_path/activenet-package
echo -e '\nSwitching activenet-package...'
git checkout "$branch"

cd $git_path/activenet-servlet
if [ $do_stash = "y" ]; then
	echo -e '\nStashing activenet-servlet...'
	git checkout -- web/WEB-INF/deploy/pointofsale/rpcPolicyManifest/manifest.txt web/WEB-INF/wsdl/ActiveNetWSService.wsdl
	git stash
fi
echo -e '\nSwitching activenet-servlet...'
git checkout "$branch"
if [ $apply_stash = "y" ]; then
	echo -e '\nApplying stash activenet-servlet...'
	git stash apply
fi

cd $git_path/activenet-sites
echo -e '\nSwitching activenet-sites...'
git checkout "$branch"

cd $git_path/aui
echo -e '\nSwitching aui...'
git checkout "$branch"

cd $git_path/cui
echo -e '\nCleaning cui...'
git reset HEAD --hard
echo -e '\nSwitching cui...'
git checkout "$branch"

cd $git_path/databases
echo -e '\nSwitching databases...'
git checkout "$branch"

cd $git_path/db-schema
echo -e '\nSwitching db-schema...'
git checkout "$branch"

cd $git_path/email-service
echo -e '\nSwitching email-service...'
git checkout "$branch"

cd $git_path/pass-production
echo -e '\nSwitching pass-production...'
git checkout "$branch"

cd $git_path/point-of-sale
echo -e '\nSwitching point-of-sale...'
git checkout "$branch"

cd $git_path/rserver-ii
echo -e '\nSwitching rserver-ii...'
git checkout "$branch"

cd $git_path/utilities
echo -e '\nSwitching utilities...'
git checkout "$branch"
