SCRIPTDIR=$ZDOTDIR/scripts

# Auto-load anything we need later
autoload -Uz vcs_info

# Include other sources
source $SCRIPTDIR/functions			# Custom functions
source $SCRIPTDIR/compsys			# Awesome completion rules
source $SCRIPTDIR/historySubstr		# fish-style history search
source $SCRIPTDIR/spectrum			# 256-bit color codes
source $SCRIPTDIR/syntaxHighlight	# command syntax highlighting
source $SCRIPTDIR/TerminalCWD		# Help Terminal.app remember CWD


# Set our options
setopt auto_cd						# cd when just a path is entered
setopt extended_glob				# extra fancy globbing
setopt append_history				# append the history file instead of replacing it
setopt hist_ignore_all_dups			# don't store duplicate entires in history
setopt hist_expire_dups_first		# expire duplicate entries in history first
setopt hist_no_store				# don't store history lookups in history


# Key bindings
bindkey -s '^O' '^qedit \eg\n'


# History variables
export HISTSIZE=5000				# history entries saved in memory
export SAVEHIST=$HISTSIZE			# history entires saved in $HISTFILE
export HISTFILE="$HOME/.history"	# history file path


# ZSH Syntax Highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


# ls Colors
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxAbabcxcx


# less options
export LESS="--tabs=4 --ignore-case -FRSX"


# Prompt colors
ZSH_PROMPT_BOLD=true
ZSH_PROMPT_COLOR_MAIN="$FG[032]"
ZSH_PROMPT_COLOR_MAIN_RIGHT="$FG[237]"
ZSH_PROMPT_COLOR_GIT_MAIN="$FG[190]"
ZSH_PROMPT_COLOR_GIT_UNTRACKED="$FG[200]"
ZSH_PROMPT_COLOR_GIT_AHEAD="$FG[014]"
ZSH_PROMPT_COLOR_GIT_BEHIND="$FG[166]"
ZSH_PROMPT_COLOR_GIT_SEP="$FG[190]"
ZSH_PROMPT_COLOR_NO_SUCCESS="$FG[200]"


# Version control info
zstyle ':vcs_info:*' enable git #svn
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '⚡ '
zstyle ':vcs_info:git*' formats "%{${ZSH_PROMPT_COLOR_GIT_MAIN}%}(%b%{${ZSH_PROMPT_COLOR_GIT_UNTRACKED}%}%c%u%{${ZSH_PROMPT_COLOR_GIT_MAIN}%}%m)"
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-untracked
+vi-git-untracked(){
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		# This will show the marker if there are any untracked files in repo.
		# If instead you want to show the marker only if there are untracked
		# files in $PWD, use:
		#[[ -n $(git ls-files --others --exclude-standard) ]] ; then
		hook_com[unstaged]+="🍺 "
	fi
}
+vi-git-st() {
	local sep ahead behind
	local -a gitstatus

	ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l | tr -d " ")
	(( $ahead )) && gitstatus+=( "%{${ZSH_PROMPT_COLOR_GIT_AHEAD}%}↑${ahead}" )

	behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l | tr -d " ")
	(( $behind )) && gitstatus+=( "%{${ZSH_PROMPT_COLOR_GIT_BEHIND}%}↓${behind}" )

	if [[ ${#gitstatus[@]} -ne 0 ]]; then
		if [[ ${#gitstatus[@]} -gt 1 ]]; then
			sep="%{$ZSH_PROMPT_COLOR_GIT_SEP%}|${gitstatus[2]}"
		fi
		hook_com[misc]=" ${gitstatus[1]}${sep}%{${ZSH_PROMPT_COLOR_GIT_MAIN}%}"
	fi
}

# Setup our prompts
precmd() {
	vcs_info

	PS1="%{${ZSH_PROMPT_COLOR_MAIN}%}"
	RPS1="%{${ZSH_PROMPT_COLOR_MAIN_RIGHT}%}"

	if $ZSH_PROMPT_BOLD; then
		PS1+="%{$FX[bold]%}"
		RPS1+="%{$FX[bold]%}"
	fi
	if [[ -n ${vcs_info_msg_0_} ]]; then
		PS1+="%3~ ${vcs_info_msg_0_}"
	else
		PS1+="%5~"
	fi

	if [[ $UID -eq 0 ]]; then
		RPS1+="%{$FG[160]%}"
	else
		RPS1+="%{$ZSH_PROMPT_COLOR_MAIN_RIGHT%}"
	fi

	battery_status=$(get_battery_status 1)
	if [[ battery_status -le 75 ]]; then
		if [[ battery_status -gt 50 ]]; then
			color="$FG[010]"
		elif [[ battery_status -gt 25 ]]; then
			color="$FG[011]"
		else
			color="$FG[009]"
		fi

		battery_status=" %{${color}%}${battery_status}%%%{${reset_color}%}"
	fi


	PS1+="%{$ZSH_PROMPT_COLOR_MAIN%} %(0?..%{${ZSH_PROMPT_COLOR_NO_SUCCESS}%})%(!.#.%%)%{${reset_color}$FX[reset]%} "
	RPS1+="%n@%m${battery_status}%{${reset_color}$FX[reset]%}"
}


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