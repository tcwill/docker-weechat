#!/bin/sh
#
# Preconfigure the booted docker image with SSH keys
#

USER=$1

if [ -z "$PUB_KEYS" ]; then
  echo "You need to set your public key in PUB_KEYS environment variable"
  exit 10
fi

mkdir -p /home/$USER/.ssh
echo "$PUB_KEYS" > /home/$USER/.ssh/authorized_keys
chown -R ${USER}. /home/$USER/.ssh

# now run ssh:

/usr/sbin/sshd -D -o "AuthenticationMethods publickey" -o "PasswordAuthentication no" 
#/usr/sbin/sshd -D -E /home/irc/sshd.log

