#!/bin/bash

# Copyright (c) 2020 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

echo 'Post Installation Started'

mv /home/gem5/serial-getty@.service /lib/systemd/system/

pushd /home/gem5/experiments
make
popd

mv /home/gem5/m5 /sbin
ln -s /sbin/m5 /sbin/gem5

mv /home/gem5/exit.sh /root/
[[ -d /etc/init/ ]] || mkdir /etc/init/
mv /home/gem5/tty-gem5.conf /etc/init/
mv /home/gem5/hosts /etc/

echo 'Post Installation Done'
