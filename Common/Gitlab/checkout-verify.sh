expected=$(grep -c -E 'git checkout "\$branch"' checkout-core.sh)
result=$(grep -c -E 'Your branch is up-to-date with' checkout.log)
# Exclude the two occurrences in stash result.
if [ $result -ge 2 ]; then
	result=$[$result-2]
fi
if [ $result -eq $expected ]; then
	echo "Done. ($result switched)"
else
	echo "Switched $result of $expected. View details in checkout.log"
fi
