# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

### AAA ##########################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export LD_LIBRARY_PATH="/opt/oci"
# export NLS_LANG='RUSSIAN_RUSSIA.AL32UTF8'
# export NLS_DATE_FORMAT='DD.MM.YYYY'
# export NLS_CURRENCY='р.'
# export NLS_DUAL_CURRENCY='р.'
# export NLS_CALENDAR='GREGORIAN'
# export NLS_ISO_CURRENCY='RUSSIA'

export JAVA_HOME="/usr/bin/"
export ANDROID_SDK_ROOT="$HOME/android/sdk"
export LITE_SCALE=1 # workaround https://github.com/lite-xl/lite-xl/issues/1173

export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$HOME/.config/composer/vendor/bin:$PATH"

# The next line updates PATH for Yandex Cloud CLI.
if [ -f "$HOME/yandex-cloud/path.bash.inc" ]; then source "$HOME/yandex-cloud/path.bash.inc"; fi

# The next line enables shell command completion for yc.
if [ -f "$HOME/yandex-cloud/completion.zsh.inc" ]; then source "$HOME/yandex-cloud/completion.zsh.inc"; fi
