#! /bin/bash
#Example: $ bash checkout.sh ActiveNet19.12
log_file="checkout.log"
if test -f "$log_file"; then
	echo -e "" > $log_file
fi
bash checkout-core.sh $1 $2 $3 $4 > $log_file
echo
bash checkout-verify.sh