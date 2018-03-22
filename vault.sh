#!/bin/bash
if [ "$#" -ne  "5" ]
	then
		echo -ne "Usage: $0 wallet_address privatekey_filename encryption_password repeat_encryption_password wallet_name\n\n"
		exit 1
	elif [ "$3" != "$4" ]
		then
			echo -ne "Passwords don't match\n\n"
			exit 1
	else
		ADDRESS=$1
		KEYFILE=$2
		PASSWD=$3
		WALLETNAME=$5
		#PATH1=vault1
		#PATH2=vault2

		# Sample Vaults in Directory vault1 and vault2. This could be changed to S3 Buckets, or other mean of secure file storage
		#mkdir $PATH1
		#mkdir $PATH2

		#Split keyfile (64 bytes) in two. This generates two files called xaa and xab 32 bytes each
		#This should be adapted for Bitcoin's 12-words key files
		split -b 32 $KEYFILE

		#Generate two filenames
		FILE1=`echo $ADDRESS | md5`
		FILE2=`cat xab | md5`

		#Creating File 1
		#The first part of the private key will be encrypted using your password as encryption key
		#The second part of the private key will be encrypted using the address as encryption key
		echo ":$FILE2" >> xaa
		openssl aes-256-cbc -k $PASSWD -a -in xaa > $FILE1

		#Creating File 2
		openssl aes-256-cbc -k $ADDRESS -a -in xab > $FILE2

		qrencode -r $FILE1 -o $FILE1.png
		qrencode "FILENAME: $FILE1" -o qr1.png
		qrencode -r $FILE2 -o $FILE2.png
		qrencode "FILENAME: $FILE2" -o qr2.png
		qrencode "WALLET: $ADDRESS" -o wallet.png

		#safe deleting plaintext file 1 and 2 //work in progress
		#echo 0000 > xaa
		#echo 0000 > xab
		#rm xa*
		gshred -vuf xa*

		#FILE 1
		mogrify -extent 800x300 $FILE1.png
		mogrify -gravity SouthWest -pointsize 12 -undercolor white -fill black -annotate +30+30 "WALLET ADDRESS: $ADDRESS\n\nFILENAME $FILE1\n\nFILE CONTENT:\n`cat $FILE1`" $FILE1.png
		mogrify -gravity NorthEast -pointsize 22 -undercolor white -fill black -annotate +200+30 "$WALLETNAME" $FILE1.png
		composite -gravity NorthEast qr1.png $FILE1.png $WALLETNAME-1.png
		composite -gravity SouthEast wallet.png $WALLETNAME-1.png $WALLETNAME-F1.png

		#FILE 2
		mogrify -extent 800x300 $FILE2.png
		mogrify -gravity SouthWest -pointsize 12 -undercolor white -fill black -annotate +30+80 "FILENAME $FILE2\n\nFILE CONTENT:\n`cat $FILE2`" $FILE2.png
		mogrify -gravity NorthEast -pointsize 22 -undercolor white -fill black -annotate +200+30 "$WALLETNAME" $FILE2.png
		composite -gravity NorthEast qr2.png $FILE2.png $WALLETNAME-F2.png
fi

gshred -vuf $WALLETNAME-1.png
gshred -vuf $FILE1*
gshred -vuf $FILE2*
gshred -vuf qr*.png
gshred -vuf wallet.png
