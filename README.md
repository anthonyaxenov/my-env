# My Ubuntu environment

`make`-ready bunch of scripts for easily installation of different software.

## Requirements

* Ubuntu >= 20.04 (not tested with version < 20)
* `bash`, `zsh` or other `sh`-compatible shell
* `make` (optional but recommended)
* `wget` (necessary for some scripts)
* `git` (necessary for some scripts)

If some dependecies are missed for some of these scripts it is enougth to run `./install/apt` in most cases.

## Usage

### Clone this repo (recommended)

```shell
# if git is installed
git clone git@git.axenov.dev:anthony/my-env.git --depth=1

# if git is not installed
wget -qO - https://git.axenov.dev/anthony/my-env/archive/master.tar.gz | tar -zxf -

# switch to repo dir
cd my-env

# generate fresh ./Makefile and get full list of `make` goals
./gen-makefile

# get full list of `make` goals
make
```

### Selective straightforward installation

```shell
# from remote file
wget -qO - https://git.axenov.dev/anthony/my-env/raw/branch/master/install/apt | bash

# from locally cloned repo
./install/apt
```

## How to add a new software script?

1. Create new `./install/*` script.  
   At the beggining of a file you must write these two lines:
   ```shell
   #!/bin/bash
   ##makedesc: Your description for Makefile
   ```
2. Test your script
3. Run `./gen-makefile` to generate new `./Makefile`

## How to create packs?

You can create new file inside `./packs` dir.

Syntax is same as classic makefile with one important and necessary addition -- a comment started with `##`:

```makefile
##mypack1: Pack description
mypack1: goal1 goal2 goalX ...
   ...

##mypackX: Pack description
mypackX: goalA goalB
   @cp file1 file2
   ...
...
```

where:
* `mypack*` is the pack name
* `goal*` are script names in `./install`

## Testing in docker (not recommended)

> Note that this is almost useless way to test since you'll meet errors in many cases because dockerized OS is not fully-functional and will never be.
> 
> You can use docker to test something **really simple**, e.g. to check general script steps or install cli tools.
>
> In other cases you need virtualized Ubuntu instead of dockerized one, so I strongly recommend you to use [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or your host machine.

```shell
# switch to repo dir
cd my-env

# build and run container 
docker build -t myenv . && docker run -it myenv

# or oneliner
docker run -it $(docker build -q .)
```

Now you can play around with scripts.

## TODO

* build: [flameshot](https://github.com/flameshot-org/flameshot#compilation)
* build: [rustdesk](https://github.com/rustdesk/rustdesk#build)
* [JB mono](https://www.jetbrains.com/ru-ru/lp/mono/#how-to-install) ([2](https://fonts.google.com/specimen/JetBrains+Mono))
* update scripts (when possible)
* uninstall scripts (when possible)

## License

[WTFPLv2](LICENSE)
