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

build_m5term() {
  docker run --rm -itv $BASE:/mnt -w /mnt/gem5/util/term $CONTAINER make
}

build_disk() {
  DISK_DIR=$BASE/disk-image/x86-ubuntu/x86-ubuntu-image
  [[ -d $DISK_DIR ]] && rm -rf $DISK_DIR
  docker run --privileged --rm -itv $BASE:/mnt -w /mnt/disk-image $CONTAINER bash build.sh
}

run() {
  NAME=gem5cxl
  CMD="/mnt/gem5/util/term/m5term localhost 3456"
  docker run --privileged --rm -itv $BASE:/mnt -w /mnt $CONTAINER bash -c "
  tmux kill-session -t $NAME;
  tmux new-session -d -s $NAME;
  tmux split-window -h -t $NAME:0.0;
  tmux send-keys -t $NAME:0.0 \"/mnt/gem5/build/X86/gem5.opt --debug-flags CxlController,CxlMemory x86-ubuntu-run-cxl-kvm.py\" Enter;
  tmux send-keys -t $NAME:0.1 \"while true; do $CMD; sleep 1; done\" Enter;
  tmux attach-session -t $NAME;"
}

all() {
  build_container
  build_gem5
  build_m5
  build_m5term
  build_disk
  run
}

if [[ -z $1 ]]
then
    all
else
    $@
fi
