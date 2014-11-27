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

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin"

function try_source {
	[ -f "$1" ] && source "$1"
}

if [ $(uname) = 'Darwin' ]; then
	export PATH=/Library/Frameworks/Python.framework/Versions/3.4/bin/:$PATH
	export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin/

	export VIRTUALENVWRAPPER_PYTHON=$(which python3.4)
	export DOCKER_HOST=tcp://debian.local:2375

	try_source "$HOME/bin/virtualenvwrapper.sh"
else
	try_source /usr/local/bin/virtualenvwrapper.sh
fi

export PATH=$HOME/bin/:$PATH

try_source "$HOME/.travis/travis.sh"

alias sshu="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scpu="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
