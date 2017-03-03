# dev-box
This is a dockerized vim installation that shares your system clipboard. Edit code on your local machine by exposing it to the container with a volume.

## Features
* vim 8.*, with its [new, built-in package system](https://shapeshed.com/vim-packages/)
* zsh, configured via [prezto](http://wikimatze.de/better-zsh-with-prezto)

## 1. Setup docker on your local machine
### Mac OS
TODO

### Windows
TODO

### 2. Using NFS for mounts
This project relies on docker volumes. Unfortunately, docker volumes are [slower than the real filesystem](https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076/12). Right now, the best we can do is use NFS.
### Mac OS

NFS (Network File System) is _much_ faster for file reads inside of virtualbox. Since our applications read a ton of files to operate (think: every ruby gem and their files), it's recommended to use NFS for mounted volumes.

Luckily, this is super easy to do with the tool https://github.com/adlogix/docker-machine-nfs

```sh
$ brew install docker-machine-nfs
$ docker-machine-nfs <machine name> --mount-opts="noacl,async,nolock,vers=3,udp,noatime,actimeo=1"
```

This will configure NFS against your VirtualBox VM and Mac OSX.

### Windows
TODO

## 3. Build the image
```bash
docker build -t dev-box .
```

## 4. Prepare you local machine to share its clipboard with a docker container
### Mac OS
In your normal shell:
```bash
brew install socat
brew cask install xquartz
open -a XQuartz
```
In your quartz shell:
```bash
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```
In your normal shell:
```bash
vboxip=$(ifconfig | grep -A 2 vbox | grep inet | awk '{ print $2 }')
```
### Windows
Untested: https://github.com/docker/docker/issues/8710#issuecomment-135109677

## 5. Start it
From the project root of this app, run:
```bash
./run /path/to/project/root
```
This will put you inside the docker container with your project root loaded via volumes. If you `exit`, the container will clean itself up. If you accidentally drop out of it without editing, the container will live on, and you can find it via `docker ps --filter "name=dev-box" --format "table {{.Names}}"`. You'll see the container is named `dev-box-<PROJECT ROOT DIRECTORY NAME>`.

## 5. Alias it
Assuming you've cloned this repo to ~/dev-box:
```bash
alias dvim="~/dev-box/run $(pwd)"
```

### 6. Read and write to your local machine clipboard from vim
The system clipboard is the `+` register, so for example, you can yank a word into it with `"+yw`

### 7. TODO
* Share ssh with local machine so git fetches work
* Offer command for removing trailing whitespaces
* Comment block
* Relative line number
* Fix line-move command
* Fix syntastic linting
* Add cucumber go-to-step
* Add "surround" plugin
* Research how to reload vim buffers automatically when underlying file changes, rather than prompt the user on save
* Stop ctrl-s from freezing the terminal
* Use vim mode on the commandline (maybe `set -o vi`)

## Attribution
* [Jim Walker](https://github.com/poopoothegorilla) had the awesome idea of putting vim in a docker container
* [Yan Pritzer](https://github.com/skwp) maintains an amazing set of dotfiles [here](https://github.com/skwp/dotfiles)
* [Bryan Yap](https://github.com/yggie) for introducing me to skwp's dotfiles with [this blogpost](https://www.agileventures.org/articles/setting-up-yadr-on-ubuntu)
