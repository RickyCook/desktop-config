# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kphoen-thatpanda"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="node_modules/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin"

if [ -e "$HOME/.profile" ]; then
	source "$HOME/.profile"
fi

function try_source {
	[ -f "$1" ] && source "$1"
}

if [ $(uname) = 'Darwin' ]; then
	export PATH=/Library/Frameworks/Python.framework/Versions/3.4/bin/:$PATH
	export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin/

	export VIRTUALENVWRAPPER_PYTHON=$(which python3.4)

	try_source "$HOME/bin/virtualenvwrapper.sh"
else
	try_source /usr/local/bin/virtualenvwrapper.sh
fi

try_source "$HOME/.travis/travis.sh"
try_source "$HOME/.fzf.zsh"
try_source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
try_source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
try_source /opt/boxen/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
try_source ~/google-cloud-sdk/path.zsh.inc
try_source ~/google-cloud-sdk/completion.zsh.inc

which pyenv > /dev/null && eval "$(pyenv init -)"

if [ -e "/opt/boxen/homebrew/Cellar/zsh-completions" ]; then
    source /opt/boxen/homebrew/Cellar/zsh-completions/0.12.0/share/zsh-completions/*
fi

alias sshu="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scpu="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias gdone='GDONEWITH=$(git rev-parse --abbrev-ref HEAD); git checkout master && git pull && git branch -d $GDONEWITH'

export EDITOR="$(which vim)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
