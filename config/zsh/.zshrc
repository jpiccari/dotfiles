#!/usr/bin/env zsh

SCRIPTDIR="$ZDOTDIR/scripts"

# Auto-load anything we need later
autoload -Uz vcs_info

# Include other sources
source "$SCRIPTDIR/spectrum"		# 256-bit color codes
source "$SCRIPTDIR/functions"		# Custom functions
source "$SCRIPTDIR/historySubstr"	# fish-style history search
source "$SCRIPTDIR/commandPrompt"	# Command prompt settings
source "$SCRIPTDIR/TerminalCWD"		# Help Terminal.app remember CWD
source "$SCRIPTDIR/compsys"			# Awesome completion rules
source "$SCRIPTDIR/syntaxHighlight"	# command syntax highlighting


# Set our options
setopt auto_cd						# cd when just a path is entered
setopt extended_glob				# extra fancy globbing
setopt append_history				# append the history file instead of replacing it
setopt hist_ignore_all_dups			# don't store duplicate entires in history
setopt hist_expire_dups_first		# expire duplicate entries in history first
setopt hist_no_store				# don't store history lookups in history


# Key bindings
bindkey -s '^O' '^qsubl \eg\n'


# History variables
export HISTSIZE=5000				# history entries saved in memory
export SAVEHIST=25000   			# history entires saved in $HISTFILE
export HISTFILE="$HOME/.history"	# history file path


# ZSH Syntax Highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


# ls Colors
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxAbabcxcx


# less options
export LESS="--tabs=4 --ignore-case -FRSX"


# Start ssh-agent and add ssh keys
SSH_AGENT_ENV="$HOME/.ssh/agent.env"

if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ ! -f "$SSH_AGENT_ENV" ]; then
        (umask 066; ssh-agent -s > "$SSH_AGENT_ENV")
    fi

    source "$SSH_AGENT_ENV" >& /dev/null
fi

# Load ssh keys
ssh-add $(find -E "$HOME/.ssh" -iregex '.*_[dr]sa') >& /dev/null


# Setup ruby
if command -v rbenv >& /dev/null; then
    eval "$(rbenv init -)"
fi

# If docker-machine exists, setup the proper env
if command -v docker-machine >& /dev/null; then
    # Get the first docker vm as a fallback
    local docker_vm=$(docker-machine ls -q | head -1)

    # If a "default" vm exists, use it instead
    if $(docker-machine ls -q | grep -q default); then
        docker_vm="default"
    fi

    if [ -n "$docker_vm" ]; then
        if [ $(docker-machine status "$docker_vm") != "Running" ]; then
            echo "Starting docker vm \"$docker_vm\""
            docker-machine start "$docker_vm" >& /dev/null
            sleep 5
        fi

         eval $(docker-machine env "$docker_vm")
     fi
fi


# ZSH handler for when a command is not found
command_not_found_handler() {
	local url tpgid

	# do not run when inside Midnight Commander or within a Pipe
	if [ -n "$MC_SID" -o ! -t 1 ]; then
        return 127
    fi


    # do not run when within a sub-shell
	ps o tpgid | sed -n 2p | read tpgid
	if [ $$ -eq $tpgid ]; then
        return 127
	fi


	# open url if its not a command
	url=$(normalize_url $*)
	if is_url $url; then
		open $url
		return 0;
	fi


    # Standard error message
    return 127
}
