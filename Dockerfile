FROM debian:buster

ARG user_id=1000
ARG toolchain_file=opendingux-gcw0-toolchain.2020-10-01.tar.gz

# Install mandatory dependencies
# https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN apt-get update && apt-get install -y -q \
        bash \
        bc \
        binutils \
        build-essential \
        bzip2 \
        ca-certificates \
        cpio \
        debianutils \
        file \
        g++ \
        gcc \
        git \
        graphviz \
        gzip \
        libncurses5-dev \
        locales \
        make \
        patch \
        perl \
        python \
        python-matplotlib \
        rsync \
        sed \
        tar \
        unzip \
        wget

RUN apt-get update && apt-get install -y -q \
        bison \
        bzr \
        flex \
        gcc-multilib \
        genext2fs \
        gettext \
        libc6-dev-i386 \
        libvorbis-dev \
        libxext-dev \
        mercurial \
        mlocate \
        nano \
        default-jdk \
        subversion \
        sudo \
        texinfo \
        tree \
        vim

# shave some space
RUN apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# set up toolchain
# let's get the latest from http://www.gcw-zero.com/develop
RUN mkdir -p /opt
RUN cd /opt \
        && wget http://od.abstraction.se/opendingux/$toolchain_file \
        && tar xvfa ./$toolchain_file \
        && rm -f ./$toolchain_file

ENV PATH="/opt/gcw0-toolchain/usr/bin:${PATH}:/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/bin"
ENV CC=mipsel-linux-gcc

# fix locales
RUN sed -i "s/^# en_GB.UTF-8/en_GB.UTF-8/" /etc/locale.gen && locale-gen && update-locale LANG=en_GB.UTF-8

RUN useradd -m docker -u ${user_id} -g users -G sudo && echo "docker:docker" | chpasswd

WORKDIR /buildroot

# and hand over to the interactive shell
