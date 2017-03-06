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

# Add sublime to the path
export PATH=$PATH:"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
source /usr/local/bin/virtualenvwrapper_lazy.sh

# virtual env
export WORKON_HOME=~/.virtualenvs

# Autoload rbenv
eval "$(rbenv init -)"

# Import aliases
source ~/.aliases

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samcook/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/samcook/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samcook/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/samcook/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
