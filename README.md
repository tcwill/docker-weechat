# docker-weechat

Weechat on Docker

## Usage

The image is designed to boot directly into ssh, and you can ssh into the docker image with your public key.  You'll need to boot it with the right options:

```bash
WEECHAT_ID=$(docker run -d -p 22 -e PUB_KEYS="<content of public key>" amdtech/weechat)
```

> If you don't set the `PUB_KEYS` environment variable, the logs will show that and the image will not boot.

To get the port weechat is running on, run the following:

```bash
DOCKER_IP=$(curl --silent icanhazip.com)
WEECHAT_PORT=$(docker port $WEECHAT_ID 22 | cut -d: -f2)
```

Once you've done that, you can ssh to the image with:

```bash
ssh -l docker $DOCKER_IP -p $WEECHAT_PORT
```

If you don't want to deal with this, you can boot the image with a designated public port so it never changes:

```bash
docker run -d -p 19122:22 -e PUB_KEYS="<content of public key>" amdtech/weechat
```

## Building

You can either use the trusted build on the index, or grab this repo and build it yourself with:

```bash
docker build -t <username>/<repo> .
```
