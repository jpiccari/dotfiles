# Auto-load anything we need later
autoload -Uz compinit vcs_info
source ~/.zsh/spectrum			# 256-bit color codes


# Set our options
setopt auto_cd					# cd when just a path is entered
setopt extended_glob			# extra fancy globbing
setopt append_history			# append the history file instead of replacing it
setopt hist_ignore_all_dups		# don't store duplicate entires in history
setopt hist_expire_dups_first	# expire duplicate entries in history first
setopt hist_no_store			# don't store history lookups in history


# History variables
HISTSIZE=1000					# history entries saved in memory
SAVEHIST=$HISTSIZE				# history entires saved in $HISTFILE
HISTFILE=~/.history				# history file path


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
zstyle ':vcs_info:*' enable git svn
#zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{${ZSH_PROMPT_COLOR_GIT_MAIN}%}(%b%{${ZSH_PROMPT_COLOR_GIT_UNTRACKED}%}%c%{${ZSH_PROMPT_COLOR_GIT_MAIN}%}%m)"
zstyle ':vcs_info:git*+set-message:*' hooks git-unstaged git-untracked git-st
+vi-git-unstaged(){
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep 'M' &> /dev/null ; then
		# This will show the marker if there are any untracked files in repo.
		# If instead you want to show the marker only if there are untracked
		# files in $PWD, use:
		#[[ -n $(git ls-files --others --exclude-standard) ]] ; then
		hook_com[staged]=" ⚡"
	fi
}
+vi-git-untracked(){
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		# This will show the marker if there are any untracked files in repo.
		# If instead you want to show the marker only if there are untracked
		# files in $PWD, use:
		#[[ -n $(git ls-files --others --exclude-standard) ]] ; then
		hook_com[staged]=" ⚡"
	fi
}
function +vi-git-st() {
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

	PS1+="%{$ZSH_PROMPT_COLOR_MAIN%} %(0?..%{${ZSH_PROMPT_COLOR_NO_SUCCESS}%})%(!.#.%%)%{${reset_color}$FX[reset]%} "
	RPS1+="%n@%m$(~/.zsh/batt_status.py)%{${reset_color}$FX[reset]%}"
}


# Aliases
alias _='sudo'
alias edit='open -a /Applications/Sublime\ Text\ 2.app'		# edit [file] opens file in ST2
alias -s {com,net,org}='open_url'							# opens link with default browser
open_url() {
	open "http://$@"
}


# Use modern completion system
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
