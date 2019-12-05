expected=$(grep -c -E 'git checkout "\$branch"' checkout-core.sh)
result=$(grep -c -E 'Your branch is up-to-date with' checkout.log)

# Exclude duplicate up-to-date occurrences in stash response.
stash_apply=$(grep -c -E 'Applying stash to ' checkout.log)
result=$[$result-$stash_apply]
if [ $result -lt 0 ]; then
	result=0
fi

if [ $result -eq $expected ]; then
	echo "Done. ($result switched)"
else
	echo "Switched $result of $expected. View details in checkout.log"
fi
