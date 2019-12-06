log_file="checkout.log"

if [ -n "$1" ]; then
	log_file="$1"
fi

expected=$(grep -c -E 'git checkout "\$branch"' checkout-core.sh)
r1=$(grep -c -E 'set up to track remote branch' "$log_file")
r2=$(grep -c -E 'Your branch is up to date with' "$log_file")
r3=$(grep -c -E 'Your branch is up-to-date with' "$log_file")
result=$[$r1+$r2+$r3]

# Exclude duplicate up-to-date occurrences in stash response.
stash_apply=$(grep -c -E 'Applying stash to ' "$log_file")
result=$[$result-$stash_apply]
if [ $result -lt 0 ]; then
	result=0
fi

if [ $result -eq $expected ]; then
	echo "Done. ($result switched)"
else
	echo "Switched $result of $expected. View details in $log_file"
fi
