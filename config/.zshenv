DOTDIR="$(dirname $(readlink $HOME/.zshenv))"
export ZDOTDIR="$DOTDIR/zsh"
export TMUXDIR="$DOTDIR/tmux"

export BLOCKSIZE=K
export PAGER=less
export VISUAL=vi
# If we really need EDITOR, just give up
export EDITOR="echo \"Sad panda... you're screwed!\"; false"

export DISPLAY=:0.0
