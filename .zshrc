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
plugins=(
	colored-man-pages
	git
	kubectx
	shrink-path
	terraform
	git-prompt
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

# This is probably needed to make sure that GPG prompts for passwords correctly
GPG_TTY=$(tty)
export GPG_TTY

# Set up Go
# export GOPATH="$HOME/code/go"
# .... There used to be a load of PATH settings here but they're where they should be now
# (.zshenv)

source ~/.aliases

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -C '/opt/homebrew/bin/aws_completer' aws

if [ -x "$(command -v kubectl)" ]; then
	source <(kubectl completion zsh)
else
	print "kubectl not installed"
fi


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# setup autocd so that we can easily jump between dirs in code
setopt auto_cd
cdpath=($HOME/code)

source <(fzf --zsh)
