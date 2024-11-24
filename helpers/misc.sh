#!/bin/bash

########################################################
# Misc
########################################################

# https://askubuntu.com/a/30414
is_full_screen() {
    local WINDOW=$(echo $(xwininfo -id $(xdotool getactivewindow) -stats | \
            egrep '(Width|Height):' | \
            awk '{print $NF}') | \
            sed -e 's/ /x/')
    local SCREEN=$(xdpyinfo | grep -m1 dimensions | awk '{print $2}')
    if [ "$WINDOW" = "$SCREEN" ]; then
        return 0
    fi
    return 1
}

curltime() {
    curl -w @- -o /dev/null -s "$@" <<'EOF'
    time_namelookup: %{time_namelookup} sec\n
       time_connect: %{time_connect} sec\n
    time_appconnect: %{time_appconnect} sec\n
   time_pretransfer: %{time_pretransfer} sec\n
      time_redirect: %{time_redirect} sec\n
 time_starttransfer: %{time_starttransfer} sec\n
                     ---------------\n
         time_total: %{time_total} sec\n
EOF
}

ytm() {
    youtube-dl \
        --extract-audio \
        --audio-format flac \
        --audio-quality 0 \
        --format bestaudio \
        --write-info-json \
        --output "$HOME/Downloads/ytm/%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" \
        $*
}

docker.ip() { # not finished
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
