# If we are not running in a tmux environment, start one
if [ -z "$DISABLE_TMUX" ] && [ -z "$TMUX" ] && command -v tmux >& /dev/null; then
    exec tmux $(tmux list-sessions >& /dev/null && echo "attach" || echo "new")
fi

export PATH="$HOME/bin:$HOME/.gotools/bin:/opt/local/bin:/opt/local/sbin:$PATH"

# ls Colors
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxAbabcxcx

# less options
export LESS="--tabs=4 --ignore-case -FRSX"

# History variables
export HISTSIZE=5000                # history entries saved in memory
export SAVEHIST=25000               # history entires saved in $HISTFILE
export HISTFILE="$HOME/.history"    # history file path

# Setup NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Setup rbenv
if command -v rbenv >& /dev/null; then
	eval "$(rbenv init -)"
fi

# Start ssh-agent and add ssh keys
SSH_AGENT_ENV="$HOME/.ssh/agent.env"

if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ ! -f "$SSH_AGENT_ENV" ]; then
        (umask 066; ssh-agent -s > "$SSH_AGENT_ENV")
    fi

    source "$SSH_AGENT_ENV" >& /dev/null
fi

# Load ssh keys
ssh-add >& /dev/null

# Source local zlogin if available
[ -f "$HOME/.zlogin" ] && source "$HOME/.zlogin"
