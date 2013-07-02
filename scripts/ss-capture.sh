#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: $0 SS_TYPE"
fi

import_args=''
if [ "$1" == "full" ]; then
	import_args="$import_args -window root"
fi

file="$HOME/images/ss-$(date +%F.%H-%M-%S).png"
import $import_args "$file"

if [ $? -eq 0 ]; then
	echo $file
	exit 0
else
	echo "Could not capture screen"
	exit 1
fi