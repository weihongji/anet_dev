#! /bin/bash
# checkout-core.sh $git_path $branch $stash_changes $apply_stash

git_path=$1
branch=$2
stash_changes=$3
apply_stash=$4

cd $git_path/acm
if [ $stash_changes = "y" ]; then
	echo -e '\nStashing acm...'
	git stash
fi
echo -e '\nSwitching acm...'
git checkout "$branch"
if [ $apply_stash = "y" ]; then
	echo -e '\nApplying stash to acm...'
	git stash apply
fi

cd $git_path/activenet-cui
if [ $stash_changes = "y" ]; then
	echo -e '\nStashing activenet-cui...'
	git stash
fi
echo -e '\nSwitching activenet-cui...'
git checkout "$branch"
if [ $apply_stash = "y" ]; then
	echo -e '\nApplying stash to activenet-cui...'
	git stash apply
fi

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
if [ $stash_changes = "y" ]; then
	echo -e '\nStashing activenet-servlet...'
	git checkout -- web/WEB-INF/deploy/pointofsale/rpcPolicyManifest/manifest.txt web/WEB-INF/wsdl/ActiveNetWSService.wsdl
	git stash
fi
echo -e '\nSwitching activenet-servlet...'
git checkout "$branch"
if [ $apply_stash = "y" ]; then
	echo -e '\nApplying stash to activenet-servlet...'
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
