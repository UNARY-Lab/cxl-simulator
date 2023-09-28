#!/bin/bash -e

CONTAINER=gem5cxl
BASE=$(cd -P $(dirname ${BASH_SOURCE[0]}) && pwd)

build_container() {
  docker build -t $CONTAINER $BASE
}

build_gem5() {
  docker run --rm -itv $BASE:/mnt -w /mnt/gem5 $CONTAINER bash -c "printf '\n' | scons ./build/X86/gem5.opt -j`nproc`"
}

build_m5() {
  docker run --rm -itv $BASE:/mnt -w /mnt/gem5/util/m5 $CONTAINER scons ./build/x86/out/m5 -j`nproc`
}

build_disk() {
  DISK_DIR=$BASE/disk-image/x86-ubuntu/x86-ubuntu-image
  [[ -d $DISK_DIR ]] && rm -rf $DISK_DIR
  docker run --privileged --rm -itv $BASE:/mnt -w /mnt/disk-image $CONTAINER bash build.sh
}

run() {
  docker run --privileged --rm -itv $BASE:/mnt -w /mnt $CONTAINER gem5/build/X86/gem5.opt x86-ubuntu-run-cxl-kvm.py
}

all() {
  build_container
  build_gem5
  build_m5
  build_disk
  run
}

if [[ -z $1 ]]; then
    all
else
    $@
fi
