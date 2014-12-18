## -*- docker-image-name: "armbuild/ocs-distrib-archlinux:latest" -*-
FROM armbuild/archlinux-disk:2014-12-02
MAINTAINER Online Labs <opensource@ocs.online.net>


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
    wget


#    sudo umount $TARGET/{sys,dev,proc} || true
#    sudo mount -t proc proc $TARGET/proc
#    sudo mount -t sysfs sys $TARGET/sys
#    sudo mount -o bind /dev $TARGET/dev
#    do_in_target 'sed s/root:[^:]\+:/root:x:/ -i /etc/shadow'
#    sudo mkdir -p $TARGET/run/systemd/resolve
#    sudo cp /etc/resolv.conf $TARGET/run/systemd/resolve/resolv.conf
#    do_in_target 'curl https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | bash'
#    patch_target archlinux/patches
#    sudo mkdir -p $TARGET/root/.ssh
#    sudo cp -va /root/.ssh/authorized_keys $TARGET/root/.ssh
#    echo $LOCALES | sed 's/,/\n/' | while read loc; do
#      do_in_target "sed -e s/^\#${loc}/${loc}/ -i /etc/locale.gen"
#    done
#    do_in_target locale-gen
#    do_in_target "systemctl enable sshd.service"
#    do_in_target "systemctl disable getty@tty1.service"
#    do_in_target "systemctl enable serial-getty@ttyS0.service"
#    sudo rm -f $TARGET/run/systemd/resolve/resolv.conf
#    sudo umount $TARGET/{sys,dev,proc} || true
#    sudo umount $TARGET/{sys,dev,proc} || true
#    sudo mount -t proc proc $TARGET/proc
#    sudo mount -t sysfs sys $TARGET/sys
#    sudo mount -o bind /dev $TARGET/dev
#    sudo cp /etc/resolv.conf $TARGET/run/systemd/resolve/resolv.conf
#    do_in_target "pacman --noconfirm -Suy"
#    sudo rm -f  $TARGET/run/systemd/resolve/resolv.conf


# Patch rootfs
RUN wget -qO - http://j.mp/ocs-scripts | bash
ADD ./patches/etc/ /etc/


# TEMPORARY DEBUG ACCESS
RUN echo root:toor2 | chpasswd
RUN umask 077; mkdir /root/.ssh; echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEApvPvDbWDY50Lsx4WyUInw407379iERte63OTTNae6+JgAeYsn52Z43Oeks/2qC0gxweq+sRY9ccqhfReie+r+mvl756T4G8lxX1ND8m6lZ9kM30Rvk0piZn3scF45spmLNzCNXza/Hagxy53P82ej2vq2ewXtjVdvW20G3cMHVLkcdgKJN+2s+UkSYlASW6enUj3no+bukT+6M8lJtlT0/0mZtnBRJtqCCvF0cm9xU0uxILrhIfdYAJ1XqaoqIQLFSDLVo5lILMzDNwV+CfAotRMWIKvWomCszhVQYHCQo2Z+b2Gs0TL4DRb23fRMdeaRufnVhh5ZMlNkb2ajaL6sw== m" >> /root/.ssh/authorized_keys ; echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYQAd3JDHyDnlojqmKlVgoHYEawYKS6NIq1y81PauHPn6v8lHGSjEkcPhl1kf39+dze/NmoLEGowyjpYH6Tc7XJ1z4FQDtgdAMCL5n+cBwd1H1MFAIbFJAtLsno5HUIbO6fhUKx6nKrdUodakPS7yBiCLDUT7uuxX12WhtJAJUlNJj9Cd3o2kWYYfF12AVA0dfT8Rzsbr5JA2IRlrasyisDJxQQ00T6SWEVaJRwPFK7Ipcrqrw+XeYOAeq2Mx8/25ybsbwjXaP6N+R6xCD7Wq0JoiYpzx/qE0lD3JQShQNYPbYfYkKWoVwibKk/W3Xy1QtrPdwUXET+0SssqDxdGHt"  >> /root/.ssh/authorized_keys
