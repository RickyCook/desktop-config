#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 SS_TYPE"
fi
dir=$(dirname "$0")
url=$($dir/ss-gyazo.sh $1)
if [ $? -ne 0 ]; then
	xmessage -center "Screenshot failed: $url"
	exit 1
fi
x-www-browser "$url"
