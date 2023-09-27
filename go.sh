#!/bin/bash -e

CONTAINER=gem5cxl

docker build -t $CONTAINER .
docker run --rm -itv .:/mnt -w /mnt/gem5 $CONTAINER bash -c "printf '\n' | scons ./build/X86/gem5.opt -j`nproc`"
