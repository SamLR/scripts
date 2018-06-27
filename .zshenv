# Set the gopath and add it to path
export GOPATH="$HOME/code/go"
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/Applications/Sublime Text.app/Contents/SharedSupport/bin"
# Make terrifying and things installed by stack availablE
export PATH="${PATH}:${HOME}/code/terrafying/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/code/scripts"
# Force /usr/local to be ahead of /usr/bin in the path so we use the brew installed python
export PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${PATH}"

