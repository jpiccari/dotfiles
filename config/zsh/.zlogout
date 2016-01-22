# If this is the last open terminal, clear all the sekrets
if [ $(ps a | tail -n+2 | awk '{ print $2}' | uniq | wc -l) -le 2 ]; then
    # Flush sudo timeout
    sudo -k

    # Flush ssh keys
    ssh-add -D

    if [ -f "$SSH_AGENT_ENV" ]; then
        eval $(ssh-agent -s -k)
        rm "$SSH_AGENT_ENV"
    fi
fi
