#!/bin/bash

echo "This script is broken. It's being checked in for transport home" >2&
exit 1

DIR=$(cd $(dirname "$0"); pwd -L)

mkdir -p "~/.config"
mkdir -p "~/.xmonad"
mkdir -p "~/bin"

function do_link {
	if [ -e "$2" ] && ! [ -L "$2" ] && ! [ -d "$2" ] && ! [ -f "$2" ]; then
		echo "File exists but unknown type: $2" >&2
		return 1
	fi
	ex=0
	[ -L "$2" ] && rm "$2" || ex=1
	if [ $ex -ne 0 ]; then
		echo "Link exists and can not remove $2" >&2
		return 1
	fi
	[ -d "$2" ] || [ -f "$2" ] && mv "$2" "$2.old" || ex=1
	if [ $ex -ne 0 ]; then
		echo "Directory exists and can not move to backup $2" >&2
		return 1
	fi
	ln -s "$1" "$2"
	if [ $? -ne 0 ]; then
		echo "Could not link $0 -> $2" >&2
		return 1
	fi
	return 0
}

do_link "$DIR/.profile" "~/.profile"
do_link "$DIR/xmonad.hs" "~/.xmonad/xmonad.hs"
do_link "$DIR/tianbar" "~/.config/tianbar"
do_link "$DIR/scripts/"* "~/bin"
do_link "$DIR/xinit.d/"* "~/xinit.d"

do_link "/opt/Sublime Text 2/sublime_text" "~/bin"
do_link "/opt/google/chrome/chrome" "~/bin"
