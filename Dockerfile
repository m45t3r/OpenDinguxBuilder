FROM debian:buster

ARG user_id=1000

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

RUN apt-get install -y -q \
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
    squashfs-tools \
    subversion \
    sudo \
    texinfo \
    tree \
    vim

# shave some space
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m user -u ${user_id} -g users -G sudo && echo "user:user" | chpasswd

RUN su - user -c "git clone https://github.com/tonyjih/RG350_buildroot"
RUN su - user -c "cd RG350_buildroot \
    && export BR2_JLEVEL=0 \
    && make rg350_defconfig BR2_EXTERNAL=board/opendingux \
    && make toolchain"

# ENV PATH="${PATH}:/opt/gcw0-toolchain/usr/bin:/opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr/bin"

# fix locales
RUN sed -i "s/^# en_GB.UTF-8/en_GB.UTF-8/" /etc/locale.gen && locale-gen && update-locale LANG=en_GB.UTF-8


WORKDIR /buildroot

# and hand over to the interactive shell
