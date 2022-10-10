#!/bin/bash

# alias bashrc='source ~/.bashrc'
alias zshrc='source ~/.zshrc'
alias realias='source ~/.bash_aliases'
alias reload='exec ${SHELL} -l'
alias sudo='sudo ' # enable aliases to be sudo’ed
alias g='git'
alias hosts="sudo nano /etc/hosts"
alias shrug="echo '¯\_(ツ)_/¯' | xclip -selection c"

alias ..='cd ..' # zsh builtin
alias ~='cd ~' # zsh builtin
alias -- -='cd -' # zsh builtin

alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

alias free='free -h'
alias duh='du -ha --max-depth=1'
alias sduh='sudo du -ha --max-depth=1'

alias l='ls -pCFh --color=auto'
alias la='ls -pAFh --color=auto'
alias ll='ls -palFh --color=auto'

alias mkdir='mkdir -pv'
alias where='whereis' # zsh builtin

alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

alias is='type -a'
alias upgrade='sudo apt update && sudo apt upgrade -y && sudo snap refresh'
alias untargz='tar -czf'
alias mkcd="mkdir -p $1 && cd $1"
alias cl='cd $1 && ll'
alias myip='curl http://ipecho.net/plain; echo'
alias ports='netstat -tulpan'

alias ssh.pub='cat ~/.ssh/*.pub'
alias gpg.new="gpg --full-generate-key"
alias gpg.pub="gpg --armor --export $@"
alias gpg.list='gpg --list-keys --keyid-format SHORT'

alias wine='LANG=ru_RU.utf8 wine'
alias docker.prune='docker image prune -f; docker network prune -f; docker container prune -f'

# https://obsproject.com/forum/threads/how-to-start-virtual-camera-without-sudo-privileges.139783/
alias obscam="sudo modprobe v4l2loopback video_nr=2 card_label='OBS Virtual Camera'"

# Download music from Youtube or Youtube Music
# and save as top quality flac file without video
# Playlist and video/track URLs are supported
# Usage:     $ ytm https://www.youtube.com/watch\?v=dQw4w9WgXcQ
# More info: https://github.com/ytdl-org/youtube-dl
ytm() {
    youtube-dl \
        --extract-audio \
        --audio-format flac \
        --audio-quality 0 \
        --format bestaudio \
        --write-info-json \
        --output "${HOME}/Музыка/ytm/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" \
        $@
}


docker.ip() {
    if [ "$1" ]; then
        if [ "$1" = "-a" ]; then
            docker ps -aq \
            | xargs -n 1 docker inspect --format '{{.Name}}{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' \
            | sed -e 's#^/##' \
            | column -t
        elif [ "$1" = "-c" ]; then
            docker-compose ps -q \
            | xargs -n 1 docker inspect --format '{{.Name}}{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' \
            | sed -e 's#^/##' \
            | column -t
        else
            docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
            docker port "$1"
        fi
    else
        docker ps -q \
        | xargs -n 1 docker inspect --format '{{.Name}}{{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' \
        | sed -e 's#^/##' \
        | column -t
    fi
}


#################################################################################

# $1 -- file/dir path
# $2 -- permissions (0644, 0755, etc)
# own() { #TODO refactor
#     [ "$1" ] && PATH="${1/#\~/$HOME}" || {
#         echo "Error (1): path not provided"
#     }
#     echo $PATH

#     [ "$2" ] && PERM="$2" || {
#         if [ -d $PATH ]; then
#             PERM="0755"
#         elif [ -f $PATH ]; then
#             PERM="0644"
#         else
#             echo "Error (2): path not exists"
#         fi;
#     }
#     echo $PERM

#     sudo chmod $PERM -R --preserve-root $PATH
#     sudo chown $USER. -R --preserve-root $PATH
# }

# function extract {
#  if [ -z "$1" ]; then
#     # display usage if no parameters given
#     echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
#     echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
#     return 1
#  else
#     for n in $@
#     do
#       if [ -f "$n" ] ; then
#           case "${n%,}" in
#             *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
#                          tar xvf "$n"       ;;
#             *.lzma)      unlzma ./"$n"      ;;
#             *.bz2)       bunzip2 ./"$n"     ;;
#             *.rar)       unrar x -ad ./"$n" ;;
#             *.gz)        gunzip ./"$n"      ;;
#             *.zip)       unzip ./"$n"       ;;
#             *.z)         uncompress ./"$n"  ;;
#             *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
#                          7z x ./"$n"        ;;
#             *.xz)        unxz ./"$n"        ;;
#             *.exe)       cabextract ./"$n"  ;;
#             *)
#                          echo "extract: '$n' - unknown archive method"
#                          return 1
#                          ;;
#           esac
#       else
#           echo "'$n' - file does not exist"
#           return 1
#       fi
#     done
# fi
# }
