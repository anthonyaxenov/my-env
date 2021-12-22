#!/bin/bash
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

########################################################
# Иконки
########################################################

IINFO="[ i ]"
INOTE="[ * ]"
IWARN="[ # ]"
IERROR="[ ! ]"
IFATAL="[ @ ]"
ISUCCESS="[ ! ]"
IASK="[ ? ]"

########################################################
# Атрибуты текста (форматирование)
########################################################

BOLD="\e[1m"    # жирный
_BOLD="\e[21m"  # нежирный
DIM="\e[2m"     # приглушённый
_DIM="\e[22m"   # неприглушённый

NORMAL="\e[20m" # сброс всех атрибутов
RESET="\e[0m"   # сброс всех атрибутов и цветов (вообще)

########################################################
# Цвет текста
########################################################

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

########################################################
# Цвет фона текста
########################################################

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

########################################################
# Функции для вывода текста
########################################################

print() {
    echo -e "$*${RESET}"
}

ask() {
    IFS= read -rp "$(print ${BOLD}${BBLUE}${FWHITE}${IASK}${BRESET}\ ${BOLD}$1 ): " $2
}

dbg() {
    print "${DIM}$*"
}

info() {
    print "${BOLD}${FWHITE}${IINFO}${RESET}${FWHITE} $1 "
}

note() {
    print "${BOLD}${DIM}${FWHITE}${INOTE}${RESET} $1 "
}

success() {
    print "${BOLD}${BGREEN}${FWHITE}${ISUCCESS}${BRESET}$FGREEN $1 "
}

warn() {
    print "${BOLD}${BYELLOW}${FBLACK}${IWARN}${BRESET}${FYELLOW} Warning:${RESET} $1 " >&2
}

error() {
    print "${BOLD}${BLRED}${FWHITE}${IERROR} Error: ${BRESET}${FLRED} $1 " >&2
}

fatal() {
    print "${BOLD}${BRED}${FWHITE}${IFATAL} FATAL: $1 " >&2
}

########################################################
# Тестирование
########################################################

# print
# print "print test"
# print
# ask "ask test" test
# print $test
# dbg "debug test"
# info "info test"
# note "note test"
# success "success test"
# warn "warn test"
# error "error test"
# fatal "fatal test"
