# if not an interactive session exit this
[ -z "$PS1" ] && return

function parse_git_dirty {
  status=$(git status 2> /dev/null | tail -n1)
  [[ $status ]] && [[ $status != "nothing to commit, working directory clean" ]] && echo "*"
}

# two fancy functions to display the current git branch in the prompt
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"

PS1="$WHITE[$RED\$(date +%H:%M)$WHITE][$RED\u@\h:\W$GREEN\$(parse_git_dirty)\$(parse_git_branch)$WHITE]$GREEN\$ "
PS2='> '
PS4='+ '
}

# Call virtualenvwrapper's "workon" if .venv exists.
# Copied from https://gist.github.com/clneagu/7990272
# This is modified from--
# http://justinlilly.com/python/virtualenv_wrapper_helper.html
# which is linked from--
# http://virtualenvwrapper.readthedocs.org/en/latest/tips.html#automatically-run-workon-when-entering-a-directory
check_virtualenv() {
    # if a .venv file exists then take it's contents
    if [ -e .venv ]; then
        env=`cat .venv`
        # If we've moved into a different .venv update...
        if [ "$env" != "${VIRTUAL_ENV##*/}" ]; then
            echo "Found .venv in directory. Calling: workon ${env}"
            workon $env
        fi
    fi
}
# wrap cd so multiple `sources` don't create infinite recursion
venv_cd () {
    builtin cd "$@" && check_virtualenv
}

# Actually alias the cd function..
alias cd="venv_cd"

# alias junk
alias ls='ls -G'
alias l='ls -lha'
alias ..='cd ../'
# pretty grep
alias grep="grep --colour=auto"
#  SSH aliases
alias sshbit='ssh samlr@samlr.com'
# Pretty LS
export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"

# Funky git completion stuff
git_complete_script=~/.git-completion.sh
if [ -e $git_complete_script ]; then
  . $git_complete_script
else
  echo "$git_complete_script missing."
fi

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
alias gll='git log --oneline -n 5'

# Default to using python
alias python='python3'
alias pip='echo You probably want to be in an env if not use "pip3"'

# Voodoo to set up virtual env for python and misc magic
# where to save them...
export WORKON_HOME=$HOME/.virtualenvs
# where to source everything else
source /usr/local/bin/virtualenvwrapper.sh
# let pip know..
export PIP_VIRTUALENV_BASE=$WORKON_HOME

# Add postgresql to the path
export PATH=$PATH:/Library/PostgreSQL/9.3/bin

# Make sure that editors are correctly set up & have a correct path for ports
export EDITOR=vim
export PAGER=less

# Call this once everything's loaded!
proml

# Call check_virtualenv in case opening directly into a directory (e.g
# when opening a new tab in Terminal.app). Call this once everything's loaded!
check_virtualenv

