# RCFuzzer

## Installing

### required system packages
- `docker`
- `docker-compose`

### Build docker image
We have built the docker image for you, but you want to build it by yourself; here is the process.

First build baseline fuzzers and benchmarks.

```
./docker/build.sh
```

Then, build the all-in-one docker including `rcfuzzer` and all the fuzzers/benchmarks.

```
./build.sh
```

You can tune the image name/tag in these `build.sh`.

You might need to tune `_UID` and `GID` (they are hard-coded to `2000` when building the pre-built image) in `build.sh` to bypass docker volume permission issue if you don't want to use root user.

#### Build Note/Warning

The build script parallels the compilation process a lot by making the jobs runs in the background (by inserting `&` at the end of shell commands). It will takes a lot of CPU and RAM (especially during linking). Please remove `&` in build scripts (`build.sh` or `build_all.sh` under `docker/benchmark`) when you are building under less performant machines.


### Increase inotify limits
```sh
sysctl -w fs.inotify.max_user_instances=8192
sysctl -w fs.inotify.max_user_watches=524288
```
To make it persistent between reboot; add the following lines to `/etc/sysctl.conf` on the host.
```
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=524288
```

## Running
### Launching a docker container
```sh
docker run --rm --privileged -it rcfuzz /bin/bash
```
Note that, the result is not preserved. To preserve the fuzzing output, we need
to mount a docker volume.

```sh
docker run --rm --privileged -v $PWD:/work/rcfuzz -w /work/rcfuzz -it rcfuzz /bin/bash
```
This command mount (by `-v`) your current directory (`$PWD`) to `/work/rcfuzz` in the container and change the working directory to `/work/rcfuzz` (by `-w`).

Afterward, make sure the fuzzing output directory is under `/work/rcfuzz` and it will be preserved under your `$PWD`.

#### Shared Memory Size
The default size of shared memory pool is 64 MB, and you can increase it by adding `-shm-size` argument.

```sh
docker run --rm --privileged --shm-size=8gb -it rcfuzz /bin/bash
```

The above command change the size to 8 GB.

### Note for expeirments
It is supposed to run **only one** rcfuzz instance at the same time in a single container for the current implementation.

All rcfuzz instances in the same container share a single cgroup for the current implementaion.

Generating different cgroup subgroups for differnet instances is on the roadmap.

### Init
After entering the docker container, run the following commands; it will setup necessary parameters for fuzzing and create the cgroups.
```sh
sudo /init.sh
```

#### Cgroups V2
For a system that is using cgroup v2, a manual downgrade to v1 is necessary. This can be done by adding `systemd.unified_cgroup_hierarchy=0` to the kernel command line (e.g., via /etc/default/grub).

Thanks for the anonymous reviewers for suggestion.


### Fuzzing ###
All the evaluation is run by `rcfuzz` framework.
Please refer to [cli.py](./rcfuzz/cli.py) for all possible arguments.

#### rcfuzz ####

For example, we want to fuzz `exiv2` (by `-t`) using 4 fuzzers by `-f`: `AFL`, `FairFuzz`, `AFLFast`, `QSYM` (`-f all` to use all baseline fuzzers, which is the one we used in the evaluation). `-T` for the timeout (human friendly format like `1d`, `24h` or `30m`).

The fuzzing result reside in `output` (by specifying `-o`).

```sh
rcfuzz -o output -T 24h -f afl fairfuzz aflfast qsym -t exiv2
```

##### Tuning the parameter of two-phase algorithm.
- `--collection`: collection phase time (in seconds) (default: 600)
- `--execution`: execution phase time (in seconds) (default: 600)
- `--diff`: the branch difficulty (default: 100)
- `--threshold`: the bitmap difference threshold (default: 10)

## Authors
- Hyeonmin Mo <hyeonminmo@hanyang.ac.kr>
- Jongmun Yang <jongmunyang@hanyang.ac.kr>
- Yunho Kim <yunhokim@hanyang.ac.kr>


