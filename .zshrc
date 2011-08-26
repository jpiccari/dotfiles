autoload -Uz compinit
compinit

setopt auto_cd
setopt extended_glob
setopt inc_append_history

PS1="[%n@%m %~]%# "
