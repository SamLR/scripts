# Set the gopath and add it to path
export GOPATH="$HOME/code/go"
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/Applications/Sublime Text.app/Contents/SharedSupport/bin"
export PATH="${PATH}:${HOME}/code/scripts"
# Force /usr/local to be ahead of /usr/bin in the path so we use the brew installed python
export PATH="/usr/local/bin:/usr/local/sbin:${HOME}/bin:${PATH}"

# Lucid Okta gubbins
export AWS_SDK_LOAD_CONFIG=1 # loads ~/.aws/config into ~/.aws/credentials
