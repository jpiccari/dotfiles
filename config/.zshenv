export ZDOTDIR="$(dirname $(readlink $HOME/.zshenv))/zsh"

export PAGER=less
export EDITOR=nano
export VISUAL=$EDITOR
export BLOCKSIZE=K

export DISPLAY=:0.0


local proxyFile="$ZDOTDIR/proxyServer"

if [ -f "$proxyFile" ]; then
	source "$proxyFile"
fi
