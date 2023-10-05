# CXL Experiments

## Usage

`./go.sh` will build the docker container, gem5, m5, disk, and open a shell

you can also just do one task.

Examples:
- only open a shell `./go.sh run`
- only build the disk `./go.sh build_disk`

## Use CXL Device

As of now, there is one test for the device. Instead of using the Linux CXL API, I'm faking it for testing purposes by memory mapping.

**[Command register info](https://wiki.osdev.org/PCI#Command_Register)**

```
setpci -s 00:06.0 COMMAND=0x2 # enable the memory device
/home/gem5/experiments/test # run the experiment
```
