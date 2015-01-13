## -*- docker-image-name: "armbuild/ocs-distrib-archlinux:latest" -*-
FROM armbuild/archlinux-disk:2014-12-02
MAINTAINER Online Labs <opensource@ocs.online.net> (@online_en)


# Environment
ENV OCS_BASE_IMAGE armbuild/ocs-archlinux:2014-12-02


# Install packages
RUN pacman -Sy --noconfirm \
    cronie \
    curl \
    dhcpcd \
    iptables \
    less \
    man \
    mg \
    nano \
    nbd \
    ntp \
    openssh \
    vim \
    wget \
    networkmanager


# Locales
RUN sed -e s/^\#en_US.UTF-8/en_US.UTF-8/ -i /etc/locale.gen \
 && locale-gen


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


# Systemd
RUN systemctl disable getty@tty1.service \
 && systemctl disable systemd-networkd.service \
 && systemctl enable NetworkManager-wait-online.service \
 && systemctl enable serial-getty@ttyS0.service \
 && systemctl enable sshd.service \
 && systemctl enable NetworkManager \
 && systemctl enable ntpdate


# Patch rootfs
RUN wget -qO - http://j.mp/ocs-scripts | bash
ADD ./patches/etc/ /etc/
ADD ./patches/usr/ /usr/


RUN systemctl enable oc-ssh-keys \
 && systemctl enable oc-add-extra-volumes \
 && systemctl enable oc-sync-kernel-modules


# packages upgrade
RUN pacman --noconfirm -Suy
