FROM alpine


# fork of amdtech/docker-weechat
# original Dockerfile borrowed from moul/weechat
# updated to use latest weechat and a single command for installation
# to avoid the 42 layers issue

RUN \
  apk update; \
  apk upgrade; \
  apk add openssh weechat tmux; \
  mkdir -p /var/run/sshd; \
  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa; \
  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa; \
  adduser --disabled-password irc; passwd -u irc;

EXPOSE 22

# add the ash profile to the user's homedir
# this creates/re-attaches tmux session upon login
ADD user_profile /home/irc/.profile
RUN chown irc. /home/irc/.profile

# add script to setup user's pubkeys that are passed in with -e PUB_KEYS
ADD ssh.sh /usr/bin/ssh.sh
RUN chmod 755 /usr/bin/ssh.sh;


#CMD ["/usr/sbin/sshd","-D"]
CMD ["/usr/bin/ssh.sh","irc"]


