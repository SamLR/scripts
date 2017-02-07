# Path to your oh-my-zsh installation.
export ZSH=/Users/samcook/.oh-my-zsh

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
plugins=(git, bundler, sublime, gem, vagrant)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# alias junk
alias ls='ls -G'
alias l='ls -lha'
alias ..='cd ../'

# pretty grep
alias grep="grep --colour=auto"

# Git aliases
alias ga='git add'
alias gs='git status'
alias gca='git commit -a -m' # add all changes (only already added files)
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --pretty=format:"%h %s" -n 5'
alias gd='git diff'
alias gt='git tag'
alias ggraph='git log --graph --oneline --decorate --all'
alias gpush='git push'
alias gpull='git pull'
alias gll='git --no-pager log --oneline -n 5'
alias gcm='git checkout master'
alias gcb='git checkout -b'

# Vagrant aliases
alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vpro='vagrant provision'
alias vdown='vagrant halt'
alias vlist='vagrant snapshot list'
alias vsave='vagrant snapshot save'
alias vdestroy='vagrant destroy'
alias vrestore='vagrant snapshot restore'

# Add sublime to the path
export PATH=$PATH:"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
source /usr/local/bin/virtualenvwrapper_lazy.sh

# virtual env
export WORKON_HOME=~/.virtualenvs


# Autoload rbenv
eval "$(rbenv init -)"
