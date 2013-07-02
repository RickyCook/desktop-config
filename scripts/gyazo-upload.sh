#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 IMAGE_FILE"
fi

id=''
if [ -r ~/.gyazo.id ]; then
	id=$(cat ~/.gyazo.id)
fi

URL='http://gyazo.com/upload.cgi'
UA='BASHGyazo/0.1'

ERROR=$(mktemp)
response=$(curl -i -F id="$id" -F imagedata=@"$1" -A "$UA" "$URL" 2>$ERROR)

if [ $? -ne 0 ]; then
	echo "Could not upload to Gyazo:" $(<"$ERROR")
	rm "$ERROR"
	exit 1
fi
rm "$ERROR"

id=`echo "$response" | grep 'X-Gyazo-Id' | grep -Eo '[a-z0-9]+$'`
url=`echo "$response" | tail -n 1`

if [ -n "$id" ]; then
	echo $id > ~/.gyazo.id
fi
echo $url