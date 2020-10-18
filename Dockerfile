FROM debian:buster

ARG user_id=1000
# Fix repository list (the default ones are missing some packages)
RUN sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list
ENV DEBIAN_FRONTEND=noninteractive
# Fix locales and add user
RUN apt-get update && apt-get install -y -q \
        locales \
        sudo
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN useradd -m user -u ${user_id} -g users -G sudo && echo "user:user" | chpasswd

# Install mandatory dependencies
# https://buildroot.org/downloads/manual/manual.html#requirement-mandatory
RUN apt-get install -y -q \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    ca-certificates \
    cpio \
    debianutils \
    file \
    g++-multilib \
    gcc-multilib \
    git \
    graphviz \
    gzip \
    libncurses5-dev \
    make \
    mercurial \
    patch \
    perl \
    python \
    python-matplotlib \
    rsync \
    sed \
    subversion \
    tar \
    unzip \
    wget

RUN su - user -c "git clone --recurse-submodules https://github.com/od-contrib/buildroot-rg350-old-kernel"
RUN su - user -c "cd buildroot-rg350-old-kernel \
    && make rg350_defconfig BR2_EXTERNAL=board/opendingux:opks \
    && export BR2_JLEVEL=0 \
    && make toolchain"

RUN apt-get install -y -q \
    automake \
    bison \
    bzr \
    flex \
    genext2fs \
    gettext \
    libc6-dev-i386 \
    libvorbis-dev \
    libxext-dev \
    mlocate \
    nano \
    squashfs-tools \
    sudo \
    texinfo \
    tree \
    vim \
    zip

RUN su - user -c "cd buildroot-rg350-old-kernel \
    && export BR2_JLEVEL=0 \
    && make sdk"

ENV PATH="${PATH}:/home/user/buildroot-rg350-old-kernel/output/host/bin/:/home/user/buildroot-rg350-old-kernel/output/host/usr/mipsel-rg350-linux-uclibc/bin/"
ENV CC=mipsel-linux-gcc
ENV CXX=mipsel-linux-g++

# shave some space
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /buildroot

# and hand over to the interactive shell
