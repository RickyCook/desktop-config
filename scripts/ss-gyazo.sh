#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 SS_TYPE"
fi
dir=$(dirname "$0")
file=$($dir/ss-capture.sh $1)
if [ $? -ne 0 ]; then
	echo "Unable to take screenshot: $file"
	exit 1
fi
./gyazo-upload.sh "$file"
