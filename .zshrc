# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell" # Original
ZSH_THEME="gentoo-custom"

HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bundler sublime vagrant)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Set up Go
# export GOPATH="$HOME/code/go"
# .... There used to be a load of PATH settings here but they're where they should be now
# (.zshenv)

source ~/.aliases

calendar -A 0 -f /usr/share/calendar/calendar.world | cut -f2
if [ -x "$(command -v kubectl)" ]; then
	source <(kubectl completion zsh)
else
	print "kubectl not installed"
fi


