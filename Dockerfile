## -*- docker-image-name: "armbuild/ocs-distrib-archlinux:latest" -*-
FROM armbuild/archlinux-disk:2014-12-02
MAINTAINER Online Labs <opensource@ocs.online.net> (@online_en)


# Environment
ENV OCS_BASE_IMAGE armbuild/ocs-archlinux:2014-12-02


# Install packages
RUN pacman -Sy --noconfirm \
    bash-completion \
    bc \
    binutils \
    cronie \
    curl \
    dhcpcd \
    dnsutils \
    fakeroot \
    file \
    htop \
    iptables \
    less \
    localepurge \
    lsb-release \
    man \
    mg \
    nano \
    nbd \
    networkmanager \
    ntp \
    openbsd-netcat \
    openssh \
    rsync \
    rsyslog \
    screen \
    socat \
    sudo \
    tmux \
    vim \
    wget


# shunit2
RUN mkdir -p /tmp/shunit2 \
 && chown nobody /tmp/shunit2 \
 && cd /tmp/shunit2 \
 && wget https://aur.archlinux.org/packages/sh/shunit2/PKGBUILD \
 && sudo -u nobody makepkg --nocheck ./PKGBUILD \
 && pacman -U --noconfirm shunit2-*-any.pkg.tar.xz \
 && rm -rf /tmp/shunit2


# xnbd-client
RUN mkdir /tmp/build-xnbd \
    && cd /tmp/build-xnbd \
    && wget https://bitbucket.org/hirofuchi/xnbd/downloads/xnbd-0.3.0.tar.bz2 -O xnbd.tar.bz2 \
    && tar -xf xnbd.tar.bz2 \
    && cd xnbd-* \
    && pacman -Sy --noconfirm gcc automake pkg-config make \
    && cd /tmp/build-xnbd/xnbd-* \
    && ./configure --prefix=/usr/local \
    && make -j4 \
    && make install \
    && pacman -R --noconfirm gcc automake pkg-config make \
    && cd / \
    && rm -rf /tmp/build-xnbd /tmp/xnbd.tar.bz2


# Locales
RUN sed -e s/^\#en_US.UTF-8/en_US.UTF-8/ -i /etc/locale.gen \
 && locale-gen


# Systemd
RUN systemctl disable getty@tty1.service \
 && systemctl disable systemd-networkd.service \
 && systemctl enable NetworkManager-wait-online.service \
 && systemctl enable serial-getty@ttyS0.service \
 && systemctl enable sshd.service \
 && systemctl enable NetworkManager \
 && systemctl enable ntpdate


# packages upgrade
RUN pacman --noconfirm -Suy


# Patch rootfs
RUN wget -qO - http://j.mp/ocs-scripts | bash
ADD ./patches/etc/ /etc/
ADD ./patches/usr/ /usr/


# Enable Online-Labs services
RUN systemctl enable oc-ssh-keys \
 && systemctl enable oc-add-extra-volumes \
 && systemctl enable oc-sync-kernel-modules


# Remove root password
RUN passwd -d root


# Cleanup
RUN pacman-db-upgrade \
 && pacman -Rns linux-armv7 --noconfirm \
 && pacman -Sc --noconfirm \
 && rm -rf /var/cache/pacman/pkg \
 && localepurge-config && localepurge \
 && pacman-db-upgrade
