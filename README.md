# Open Dingux specific Buildroot Docker image
This repository contains files to build a Docker image for building open dingux flavoured [buildroot](http://buildroot.org/).

## How to build

Make sure you have 

- docker installed, eg. `apt-get install docker.io`.
- open dingux flavour of choice cloned. eg. `git clone https://github.com/jbd1986/RG350_buildroot.git`

Also add your self to the docker group, eg.  `usermod -a -G docker your_alias`

To create the image use the `docker build` command, and add a tag in the format of 'your_name/app_name:sem.ver.num'

eg.

```
docker build -t podulator/dingux-builder:1.0.0 .
```

## How to use

Change into your existing open dingux build root directory, and run

```
docker run -ti -v `pwd`:/buildroot podulator/dingux-builder:1.0.0
```

Now you can issue our buildroot commands, because you'll be in yr code folder

- `make rg350_defconfig`
- `make`

To detach from the container, use `ctrl-D`.

To reattach to it, run `docker ps` to get a list of running containers, find this one, and run `docker attach container_id`.
