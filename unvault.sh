#!/bin/bash
if [ "$#" -ne  "2" ]
	then
		echo -ne "Usage: $0 wallet_address encryption_password\n\n"
		exit 1
	else
		ADDRESS=$1
		PASSWD=$2
		#PATH1=vault1
		#PATH2=vault2

		#Setting filename 1
		FILE1=`echo $ADDRESS | md5`

		#Decrypting File 1
		openssl aes-256-cbc -k $PASSWD -a -d -in $FILE1 > outfile

		#Retriving value for Key Part 1
		KEY1=`awk -F':' '{print $1}' outfile`

		#Setting value for Filename 2
		FILE2=`awk -F':' '{print $2}' outfile`

		#Retriving value and decrypting Key Part 2
		KEY2=`openssl aes-256-cbc -k $ADDRESS -a -d -in $FILE2`

		#Safe deleting files //work in progress
		#echo 0000 > outfile
		#rm outfile
		gshred -vuf outfile

		#Generating full key to stdout
		echo "$KEY1$KEY2"
fi
