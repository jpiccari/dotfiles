export PATH="$HOME/bin:$HOME/.gotools/bin:/opt/local/bin:/opt/local/sbin:$PATH"

# Setup NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Setup rbenv
if command -v rbenv >& /dev/null; then
	eval "$(rbenv init -)"
fi
