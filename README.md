# CXL Experiments

## Current State

This repo does nothing useful yet, it is a WIP

## Usage

`./go.sh` will build the docker container, gem5, m5, disk, and open a shell

you can also just do one task.

Examples:
- only open a shell `./go.sh run`
- only build the disk `./go.sh build_disk`

## Use CXL Device

As of now, there is one test for the device:
```
setpci -s 00:06.0 COMMAND=0x2 # enable the device
/home/gem5/experiments/test # run the experiment
```
