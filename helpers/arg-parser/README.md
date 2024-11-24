# Argument parser for bash scripts

More info:
* 🇷🇺 [axenov.dev/bash-args](https://axenov.dev/bash-args/)
* 🇺🇸 [axenov.dev/en/bash-processing-arguments-in-a-script-when-called-from-the-shell/](https://axenov.dev/en/bash-processing-arguments-in-a-script-when-called-from-the-shell)

Tested in Ubuntu 20.04.2 LTS in:

```
bash 5.0.17(1)-release (x86_64-pc-linux-gnu)
zsh 5.8 (x86_64-ubuntu-linux-gnu)
```

## Version history

```
v1.0 - initial
v1.1 - arg(): improved skipping uninteresting args
     - arg(): check next arg to be valid value
v1.2 - removed all 'return' statements
     - arg(): error message corrected
     - new examples
v1.3 - argl(): improved flag check
     - some text corrections
v1.4 - new function argn()
     - some text corrections
v1.5 - arg(), grep_match(): fixed searching for -e argument
     - grep_match(): redirect output into /dev/null
```
