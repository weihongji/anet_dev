#! /bin/bash
#Example: $ bash checkout.sh 19.15
git_path=/c/Users/jwei/git

branch=""
if [ -z "$1" ]
then
	echo "No branch specified"
	exit 1
elif [[ $1 =~ ^[1-9][0-9].[0-9]{2}$ ]]; then
	branch="ActiveNet$1"
else
	branch=$1
fi

read -p "Switching to $branch. Press [Enter] to go..."; echo

run_pull="n"
if [ "$2" = "pull" -o "$3" = "pull" -o "$4" = "pull" ]; then
	run_pull="y"
else
	cd $git_path/acm
	existing_branch=$(git branch -a | grep $branch)
	cd ..
	if [ -z "$existing_branch" ]; then
		run_pull="y"
		echo "Haven't found $branch in local repository. Will pull codes from remote."
	fi
fi

if [ $run_pull = "y" ]
then
	bash pull.sh
fi

cd $git_path/acm
existing_branch=$(git branch -a | grep $branch)
cd ..
if [ -z "$existing_branch" ]; then
	echo -e "\n$branch does not exist."
	exit 1
fi

stash_changes="y"
if [ "$2" = "stash-no" -o "$3" = "stash-no" -o "$4" = "stash-no" ]; then
	stash_changes="n"
fi

apply_stash=$stash_changes
if [ "$2" = "apply-no" -o "$3" = "apply-no" -o "$4" = "apply-no" ]; then
	apply_stash="n"
elif [ "$2" = "apply-yes" -o "$3" = "apply-yes" -o "$4" = "apply-yes" ]; then
	apply_stash="y"
fi

log_file="checkout.log"
if [ -e "$log_file" ]; then
	echo "" > $log_file
fi

bash checkout-core.sh $git_path $branch $run_pull $stash_changes $apply_stash > $log_file
echo
bash checkout-verify.sh