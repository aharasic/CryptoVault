#!/bin/bash
BUCKET=alexharasic-backups
PAATH=Backup/Llaves/

aws s3 ls s3://$BUCKET/$PAATH --recursive --profile aharasic | awk '{print $4}' > tempfile
L=`wc -l tempfile | awk '{print $1}'`

for files in `cat tempfile`
do
	echo -ne "$files $L\n"
	#aws s3api restore-object --restore-request Days=365 --bucket operatio-clients-devel --key cafehaiti/-KtIgqnyYcVCbrXJpkmu/files/$files
	#aws s3api put-object-acl --profile aharasic --bucket $BUCKET --key $files --acl public-read
	aws s3api restore-object --profile aharasic --restore-request Days=365 --bucket $BUCKET --key $files
	L=$((L - 1))
done

rm tempfile
