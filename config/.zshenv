export ZDOTDIR="$(dirname $(readlink $HOME/.zshenv))/zsh"
export PATH="$HOME/bin:/opt/local/bin:/opt/local/sbin:$PATH"

export PAGER=less
export EDITOR=nano
export VISUAL=$EDITOR
export BLOCKSIZE=K

export DISPLAY=:0.0


local proxyFile="$ZDOTDIR/proxyServer"

if [[ -a $proxyFile ]]; then
	source $proxyFile
fi
