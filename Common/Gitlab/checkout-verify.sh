expected=$(grep -c -E 'git checkout "\$branch"' checkout-core.sh)
result=$(grep -c -E 'Your branch is up-to-date with' checkout.log)
# Exclude the two occurrences in stash result.
result=$[$result-2]
echo "$result of $expected switched."