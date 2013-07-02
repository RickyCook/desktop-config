#!/bin/bash
DIR=$(cd $(dirname "$0"); pwd -L)

mkdir -p "$HOME/.config/tianbar"
mkdir -p "$HOME/.xmonad"

function do_link {
	if [ -e "$2" ] && ! [ -h "$2" ] && ! [ -d "$2" ] && ! [ -f "$2" ]; then
		echo "File exists but unknown type: $2" >&2
		return 1
	fi
	if [ -h "$2" ]; then 
		rm "$2"
		if [ $? -ne 0 ]; then
			echo "Link exists and can not remove $2" >&2
			return 1
		fi
	fi
	if [ -d "$2" ] || [ -f "$2" ]; then
		mv "$2" "$2.old" || ex=1
		if [ $? -ne 0 ]; then
			echo "Directory exists and can not move to backup $2" >&2
			return 1
		fi
	fi

	file=$(basename "$2")
	dir=$(dirname "$2")
	(cd "$dir"; ln -s "$1" "./$file")
	if [ $? -ne 0 ]; then
		echo "Could not link $0 -> $2" >&2
		return 1
	fi
	return 0
}
function do_link_all {
	if ! [ -d "$1" ]; then
		return 1
	fi
	if [ -e "$2" ] && ! [ -d "$2" ]; then
		echo "Target exists but is not a directory: $2" >&2
		return 1
	fi
	if ! [ -d "$2" ]; then
		mkdir -p "$2"
	fi
	for f in $(ls "$1"); do
		do_link "$1/$f" "$2/$f"
	done
}

do_link "$DIR/.profile" "$HOME/.profile"
do_link "$DIR/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
do_link "$DIR/tianbar" "$HOME/.config/tianbar"
do_link_all "$DIR/scripts" "$HOME/bin"
do_link_all "$DIR/xinit.d" "$HOME/xinit.d"

do_link "/opt/Sublime Text 2/sublime_text" "$HOME/bin/sublime_text"
do_link "/opt/google/chrome/chrome" "$HOME/bin/chrome"
