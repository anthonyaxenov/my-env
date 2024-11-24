# My shell environment

`make`-ready bunch of scripts for easily (de)installation of different software and bunch of useful handy functions for custom scripting.

## Requirements

* Ubuntu >= 20.04 (not tested with version < 20)
* `bash`, `zsh` or other `sh`-compatible shell
* `make` (optional but recommended)
* `wget` (required for some scripts)
* `git` (required for some scripts)

If some dependecies are missed for some of these scripts it is enougth to run `./install/apt` in most cases, otherwise script will suggest (or even install) them.

## Usage

```shell
# with git
git clone git@git.axenov.dev:anthony/my-env.git --depth=1 --single-branch

# without git
wget -qO - https://git.axenov.dev/anthony/my-env/archive/master.tar.gz | tar -zxf -

# get full list of `make` goals
cd my-env && make
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
* `mypack*` is the pack name of your choice
* `goal*` are script names in `./install`

## Useful links and sources used

* https://gist.github.com/anthonyaxenov/d53c4385b7d1466e0affeb56388b1005
* https://gist.github.com/anthonyaxenov/89c99e09ddb195985707e2b24a57257d
* ...and other my [gists](https://gist.github.com/anthonyaxenov/) with [SHELL] prefix
* https://github.com/nvie/gitflow/blob/develop/gitflow-common (BSD License)
* https://github.com/petervanderdoes/gitflow-avh/blob/develop/gitflow-common (FreeBSD License)
* https://github.com/vaniacer/bash_color/blob/master/color
* https://misc.flogisoft.com/bash/tip_colors_and_formatting
* https://www-users.york.ac.uk/~mijp1/teaching/2nd_year_Comp_Lab/guides/grep_awk_sed.pdf
* https://www.galago-project.org/specs/notification/
* https://laurvas.ru/bash-trap/
* https://stackoverflow.com/a/52674277
* https://rtfm.co.ua/bash-funkciya-getopts-ispolzuem-opcii-v-skriptax/
* https://gist.github.com/jacknlliu/7c51e0ee8b51881dc8fb2183c481992e
* https://gist.github.com/anthonyaxenov/d53c4385b7d1466e0affeb56388b1005
* https://github.com/nvie/gitflow/blob/develop/gitflow-common
* https://github.com/petervanderdoes/gitflow-avh/blob/develop/gitflow-common
* https://gitlab.com/kyb/autorsync/-/blob/master/
* https://lug.fh-swf.de/vim/vim-bash/StyleGuideShell.en.pdf
* https://www.thegeekstuff.com/2010/06/bash-array-tutorial/
* https://www.distributednetworks.com/linux-network-admin/module4/ephemeral-reserved-portNumbers.php

## License

[WTFPLv2](LICENSE) but other licences are also possible.
