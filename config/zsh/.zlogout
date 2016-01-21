# Flush sudo timeout
sudo -k

# Flush ssh keys
echo $(( $(cat "$SSH_AGENT_REF") - 1 )) > "$SSH_AGENT_REF"

if [ $(cat "$SSH_AGENT_REF") -le 0 ]; then
    ssh-add -D
    rm "$SSH_AGENT_REF"

    if [ -f "$SSH_AGENT_ENV" ]; then
        eval $(ssh-agent -s -k)
        rm "$SSH_AGENT_ENV"
    fi
fi
