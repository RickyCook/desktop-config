#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 SS_TYPE"
fi
file=$(/usr/local/bin/ss-capture.sh $1)
if [ $? -ne 0 ]; then
	echo "Unable to take screenshot: $file"
	exit 1
fi
/usr/local/bin/gyazo-upload.sh "$file"