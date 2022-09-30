# My Ubuntu environment

`make`-ready bunch of scripts for easily installation of different software.

## Requirements

* Ubuntu >= 20.04 (not tested with version < 20)
* `bash`, `zsh` or other POSIX-compatible shell
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
# from remote file (you can meet interaction bugs this way!)
wget -qO - https://git.axenov.dev/anthony/my-env/raw/branch/master/install/apt | bash

# from locally cloned repo (except scripts from ./packs)
./install/apt
```

## How to add my script?

1. Create a new shell script in `./install`, `./upgrade` or `./uninstall` directory.  
   At the beggining of a file you must write these two lines:
   ```shell
   #!/bin/bash
   ##makedesc: Your description for Makefile
   ```
2. Make this script executable, e.g.:
   ```shell
   sudo chmod a+x ./install/myscript
   ```
3. Test your script
4. Run `make self` to generate new `./Makefile`

## How to create a pack?

You can create new file inside `./packs` dir.

Syntax is same as classic makefile.
It is important to add a comment with short description:

```makefile
# Pack description
mypack1: goal1 goal2 goalX ...
   ...

# Pack description
mypackX: goalA goalB
   @cp file1 file2
   ...
...
```

where:
* `mypack*` is the pack name
* `goal*` are script names in `./install`

## TODO

* build: [flameshot](https://github.com/flameshot-org/flameshot#compilation)
* build: [rustdesk](https://github.com/rustdesk/rustdesk#build)
* [JB mono](https://www.jetbrains.com/ru-ru/lp/mono/#how-to-install) ([2](https://fonts.google.com/specimen/JetBrains+Mono))
* update scripts (when possible)
* uninstall scripts (when possible)

## License

[WTFPLv2](LICENSE)
