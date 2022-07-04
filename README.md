# My Ubuntu environment

`make`-ready bunch of scripts for easily installation of different software.

## Prerequisites

* `bash`, `zsh` or other `sh`-compatible shell
* `make`
* `git` or `wget`

## Usage

### Clone this repo (recommended)

```shell
# if git is installed
git clone git@git.axenov.dev:anthony/my-env.git --depth=1

# if git is not installed
wget -qO - https://git.axenov.dev/anthony/my-env/archive/master.tar.gz | tar -zxf -

# switch to repo dir
cd my-env

# get full list of `make` goals
make help

# generate new ./Makefile and get full list of `make` goals
./gen-makefile.sh
```

### Selective straightforward installation

```shell
# from remote file
wget -qO - https://git.axenov.dev/anthony/my-env/raw/branch/master/install/apt.sh | bash

# from locally cloned repo
./install/apt.sh
```

## How to add a new software script?

1. Create new `./install/*.sh` script.  
   At the beggining of a file you must write these two lines:
   ```shell
   #!/bin/bash
   ##makedesc: Your description for Makefile
   ```
2. Test your script
3. Run `./gen-makefile.sh` to generate new `./Makefile`

## How to create packs?

You can create new file inside `./packs` dir.

Syntax is same as classic makefile with one important and necessary addition -- a comment started with `##`:

```makefile
##mypack1: Pack description
mypack1: goal1 goal2 goalX ...
   ...

##mypackX: Pack description
mypackY: goalA goalB
   @cp file1 file2
   ...
...
```

where:
* `mypack*` is the pack name
* `goal*` are script names in `./install`
