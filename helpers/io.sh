#!/bin/bash

########################################################
# Simple and fancy input & output
########################################################

IINFO="( i )"
INOTE="( * )"
IWARN="( # )"
IERROR="( ! )"
IFATAL="( @ )"
ISUCCESS="( ! )"
IASK="( ? )"
IDEBUG="(DBG)"
IVRB="( + )"

BOLD="\e[1m"
DIM="\e[2m"
NOTBOLD="\e[22m" # sometimes \e[21m
NOTDIM="\e[22m"
NORMAL="\e[20m"
RESET="\e[0m"

FRESET="\e[39m"
FBLACK="\e[30m"
FWHITE="\e[97m"
FRED="\e[31m"
FGREEN="\e[32m"
FYELLOW="\e[33m"
FBLUE="\e[34m"
FLRED="\e[91m"
FLGREEN="\e[92m"
FLYELLOW="\e[93m"
FLBLUE="\e[94m"

BRESET="\e[49m"
BBLACK="\e[40m"
BWHITE="\e[107m"
BRED="\e[41m"
BGREEN="\e[42m"
BYELLOW="\e[43m"
BBLUE="\e[44m"
BLRED="\e[101m"
BLGREEN="\e[102m"
BLYELLOW="\e[103m"
BLBLUE="\e[104m"

dt() {
    echo "[$(date +'%H:%M:%S')] "
}

ask() {
    IFS= read -rp "$(print ${BOLD}${BBLUE}${FWHITE}${IASK}${BRESET}\ ${BOLD}$1 ): " $2
}

print() {
    echo -e "$*${RESET}"
}

debug() {
    if [ "$2" ]; then
        print "${DIM}${BOLD}${RESET}${DIM}$(dt)${IDEBUG} ${FUNCNAME[1]:-?}():${BASH_LINENO:-?}\t$1 " >&2
    else
        print "${DIM}${BOLD}${RESET}${DIM}$(dt)${IDEBUG} $1 " >&2
    fi
}

verbose() {
    print "${BOLD}$(dt)${IVRB}${RESET}${FYELLOW} $1 "
}

info() {
    print "${BOLD}$(dt)${FWHITE}${BLBLUE}${IINFO}${RESET}${FWHITE} $1 "
}

note() {
    print "${BOLD}$(dt)${DIM}${FWHITE}${INOTE}${RESET} $1 "
}

success() {
    print "${BOLD}$(dt)${BGREEN}${FWHITE}${ISUCCESS}${BRESET}$FGREEN $1 "
}

warn() {
    print "${BOLD}$(dt)${BYELLOW}${FBLACK}${IWARN}${BRESET}${FYELLOW} Warning:${RESET} $1 "
}

error() {
    print "${BOLD}$(dt)${BLRED}${FWHITE}${IERROR} Error: ${BRESET}${FLRED} $1 " >&2
}

fatal() {
    print "${BOLD}$(dt)${BRED}${FWHITE}${IFATAL} FATAL: $1 " >&2
    print_stacktrace
}

die() {
    error "${1:-halted}"
    exit ${2:-255}
}

# var='test var_dump'
# var_dump var
# debug 'test debug'
# verbose 'test verbose'
# info 'test info'
# note 'test note'
# success 'test success'
# warn 'test warn'
# error 'test error'
# fatal 'test fatal'
# die 'test die'
