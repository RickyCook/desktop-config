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
	mkdir -p "$dir"
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

if [ ! -e  "$HOME/.vim/bundle/Vundle.vim" ]; then
	mkdir -p "$HOME/.vim/bundle"
	git clone https://github.com/gmarik/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi

do_link "$DIR/configs/.profile" "$HOME/.profile"
do_link "$DIR/configs/.vimrc" "$HOME/.vimrc"
do_link "$DIR/configs/.zshrc" "$HOME/.zshrc"
do_link "$DIR/configs/kphoen-thatpanda.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/kphoen-thatpanda.zsh-theme"
do_link_all "$DIR/scripts" "$HOME/bin"

if [ -e "$HOME/.wireshark" ]; then
	do_link "$DIR/configs/wireshark/preferences" "$HOME/.wireshark/preferences"
fi

if [ $(uname) = 'Darwin' ]; then
	MY_PYTHON="$(which python3.4)"
	MY_VIRTUALENVWRAPPER="$(dirname $MY_PYTHON)/virtualenvwrapper.sh"
	[ -e "$MY_PYTHON" ] && (
		do_link "$MY_PYTHON" "$HOME/bin/python"
		echo "Python now $MY_PYTHON"
	)
	[ -e "$MY_VIRTUALENVWRAPPER" ] && (
		do_link "$MY_VIRTUALENVWRAPPER" "$HOME/bin/virtualenvwrapper.sh"
		echo "VirtualEnvWrapper now $MY_VIRTUALENVWRAPPER"
	)

	mkdir -p "$HOME/Library/KeyBindings"
	do_link "$DIR/configs/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
else
	do_link "$DIR/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
	do_link "$DIR/tianbar" "$HOME/.config/tianbar"
	do_link_all "$DIR/xinit.d" "$HOME/xinit.d"

	do_link "/opt/sublime_text_3/sublime_text" "$HOME/bin/sublime_text"
	do_link "/opt/google/chrome/chrome" "$HOME/bin/chrome"
	do_link "/opt/Telegram/Telegram" "$HOME/bin/telegram"
fi
