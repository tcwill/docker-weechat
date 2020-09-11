# docker-weechat

Weechat on Docker

## Usage

The use case for this is to run containerized weechat on a remote linux system and allow direct SSH access via an alternate port (not 22) and a public key.  

The 'irc' login user's authorized key will be passed into the container via an environment variable specified to the docker run command line.

### Credits

This is a fork of amdtech/docker-weechat - though running on alpine instead of ubuntu to save a little space.  I really liked the use of a tmux session to capture user login directly into a persistent, running weechat instance. 

### Persistance

Normally, the container will store all the weechat configuration and components within the container, so when the container is replaced, the configuration will go away.  To fix that, we'll present the container with a weebchat config volume.

Run the following as the user that will run docker.  If you've already run weechat as this user, the ~/.weechat directory will likely already exist with the config that you've used previously. You can put the files anywhere you like to be mounted as a volume in docker, but to be consistent with running weechat without docker:
```bash
mkdir ~/.weechat
```

### Booting

The image will run sshd, and you can ssh into the docker image with a public key. 

Assumptions for the following docker run incantation:
- You want to use the same public keys as are in your user's existing ~/.ssh/authorized_keys  
- You want to use ~/.weechat to save your persistent weechat config
- To connect remotely, your host's firewall will need to be open to the specified port, 5309 (or whatever other port you want to use)

```bash
docker run -d -p 5309:22 -e PUB_KEYS="$(cat ~/.ssh/authorized_keys)" -v ~/.weechat:/home/irc/.weechat --name weechat tcwill/weechat
```

### Connecting

```bash
ssh -i <private key> irc@<remote host name/IP> -p 5309 
```

### Alternate methods of connecting

If you just want to connect to the container via ssh from the docker host, the following options should do the trick:

```bash
ssh -i <private key> irc@localhost -p 5309
```

Alternately, you could skip the port forwarding all together in the docker run command (leave out the -p 5309:22) and just connect directly to the container's IP address from the docker host:

```bash
ssh -i <private key> irc@$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" weechat) 
```

## Disconnecting

Once you've connected with the irc user you'll immediately find yourself in the weechat client within a tmux session.  

To disconnect from the tmux session, which will leave your weechat client/connection open and running, just detatch from tmux ^b-d


## Building

You can either use the trusted build on the index, or grab this repo and build it yourself with:

```bash
docker build -t <username>/<repo> .
```
