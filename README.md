# cxl-simulator

## Usage

`./go.sh` will build the docker container, gem5, m5, disk, and open a shell

you can also just do one task.

Examples:
- only open a shell `./go.sh run`
- only build the disk `./go.sh build_disk`
- only build gem5 `./go.sh build_gem5`

## Use CXL Device

As of now, there is one test for the device. Instead of using the Linux CXL API, I'm faking it for testing purposes by memory mapping.

```
/home/gem5/experiments/test # run the experiment
```
