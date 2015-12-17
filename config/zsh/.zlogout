# Flush sudo timeout
sudo -k

# Flush ssh keys
ssh-add -D
eval $(ssh-agent -s -k)
