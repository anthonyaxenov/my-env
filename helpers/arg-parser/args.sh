#!/bin/bash
#########################################################################
#                                                                       #
# Argument parser for bash scripts                                      #
#                                                                       #
# Author: Anthony Axenov (Антон Аксенов)                                #
# Version: 1.5                                                          #
# License: MIT                                                          #
#                                                                       #
#########################################################################
#                                                                       #
# With 'getopt' you cannot combine different                            #
# arguments for different nested functions.                             #
#                                                                       #
# 'getopts' does not support long arguments with                        #
# values (like '--foo=bar').                                            #
#                                                                       #
# These functions supports different arguments and                      #
# their combinations:                                                   #
#   -a -b -c                                                            #
#   -a avalue -b bvalue -c cvalue                                       #
#   -cab bvalue                                                         #
#   --arg                                                               #
#   --arg=value -ab -c cvalue --foo                                     #
#                                                                       #
# Tested in Ubuntu 20.04.2 LTS in:                                      #
#   bash 5.0.17(1)-release (x86_64-pc-linux-gnu)                        #
#   zsh 5.8 (x86_64-ubuntu-linux-gnu)                                   #
#                                                                       #
#########################################################################

#purpose    Little helper to check if string matches PCRE
#argument   $1 - some string
#argument   $2 - regex
#exitcode	0 - string valid
#exitcode	1 - string is not valid
grep_match() {
    printf "%s" "$1" | grep -qP "$2" >/dev/null
}

#purpose	Find short argument or its value
#argument	$1 - (string) argument (without leading dashes; only first letter will be processed)
#argument	$2 - (number) is it flag? 1 if is, otherwise 0 or nothing
#argument	$3 - (string) variable to return value into
#                (if not specified then it will be echo'ed in stdout)
#returns    (string) 1 (if $2 == 1), value (if correct and if $2 != 1) or nothing
#usage      To get value into var:      arg v 0 myvar    or    myvalue=$(arg 'v')
#usage      To find flag into var:      arg f 1 myvar    or    flag=$(arg 'f')
#usage      To echo value:              arg v
#usage      To echo 1 if flag exists:   arg f
arg() {
    local need=${1:0:1} # argument to find (only first letter)
    [ $need ] || {
        echo "Argument is not specified!" >&2
        exit 1
    }
    local isflag=$2 || 0 # should we find the value or just the presence of the $need?
    local retvar=$3 || 0 # var to return value into (if 0 then value will be echo'ed in stdout)
    local args=(${__MAIN_ARGS[0]}) # args we need are stored in 1st element of __MAIN_ARGS
    for ((idx=0; idx<${#args[@]}; ++idx)) do # going through args
        local arg=${args[$idx]} # current argument
        # skip $arg if it starts with '--', letter or digit
        grep_match "$arg" "^(\w{1}|-{2})" && continue
        # clear $arg from special and duplicate characters
        # e.g. 'fas-)dfs' will become 'fasd'
        local chars="$(printf "%s" "${arg}" | tr -s [${arg}] | tr -d "[:punct:][:blank:]")"
        # now we can check if $need is one of $chars
        if grep_match "-$need" "^-[$chars]$"; then # if it is
            if [[ $isflag = 1 ]]; then # and we expect it as a flag
                # then return '1' back into $3 (if exists) or echo in stdout
                [ $retvar ] && eval "$retvar='1'" || echo "1"
            else # but if $arg is not a flag
                # then get next argument as value of current one
                local value="${args[$idx+1]}"
                # check if it is valid value
                if grep_match "$value" "^\w+$"; then
                    # and return it back back into $3 (if exists) or echo in stdout
                    [ $retvar ] && eval "$retvar='$value'" || echo "$value"
                    break
                else # otherwise throw error message into stderr (just in case)
                    echo "Argument '$arg' must have a correct value!" >&2
                    break
                fi
            fi
        fi
    done
}

#purpose	Find long argument or its value
#argument	$1 - argument (without leading dashes)
#argument	$2 - is it flag? 1 if is, otherwise 0 or nothing
#argument	$3 - variable to return value into
#                (if not specified then it will be echo'ed in stdout)
#returns    (string) 1 (if $2 == 1), value (if correct and if $2 != 1) or nothing
#usage      To get value into var:      arg v 0 myvar    or    myvalue=$(arg 'v')
#usage      To find flag into var:      arg f 1 myvar    or    flag=$(arg 'f')
#usage      To echo value:              arg v
#usage      To echo 1 if flag exists:   arg f
argl() {
    local need=$1 # argument to find
    [ $need ] || {
        echo "Argument is not specified!" >&2
        exit 1
    }
    local isflag=$2 || 0 # should we find the value or just the presence of the $need?
    local retvar=$3 || 0 # var to return value into (if 0 then value will be echo'ed in stdout)
    local args=(${__MAIN_ARGS[0]}) # args we need are stored in 1st element of __MAIN_ARGS
    for ((idx=0; idx<${#args[@]}; ++idx)) do
        local arg=${args[$idx]} # current argument
        # if we expect $arg as a flag
        if [[ $isflag = 1 ]]; then
            # and if $arg has correct format (like '--flag')
            if grep_match "$arg" "^--$need"; then
                # then return '1' back into $3 (if exists) or echo in stdout
                [ ! $retvar = 0 ] && eval "$retvar=1" || echo "1"
                break
            fi
        else # but if $arg is not a flag
            # check if $arg has correct format (like '--foo=bar')
            if grep_match "$arg" "^--$need=.+$"; then # if it is
                # then return part from '=' to arg's end as value back into $3 (if exists) or echo in stdout
                [ ! $retvar = 0 ] && eval "$retvar=${arg#*=}" || echo "${arg#*=}"
                break
            fi
        fi
    done
}

#purpose    Get argument by its index
#argument   $1 - (number) arg index
#argument   $2 - (string) variable to return arg's name into
#                (if not specified then it will be echo'ed in stdout)
#returns    (string) arg name or nothing
#usage      To get arg into var:    argn 1 myvar    or    arg=$(argn 1)
#usage      To echo in stdout:      argn 1
argn() {
    local idx=$1 # argument index
    [ $idx ] || {
        error "Argument index is not specified!"
        exit 1
    }
    local retvar=$2 || 0 # var to return value into (if 0 then value will be echo'ed in stdout)
    local args=(${__MAIN_ARGS[0]}) # args we need are stored in 1st element of __MAIN_ARGS
    local arg=${args[$idx]} # current argument
    if [ $arg ]; then
        [ ! $retvar = 0 ] && eval "$retvar=$arg" || echo "$arg"
    fi
}

# Keep in mind:
# 1. Short arguments can be specified contiguously or separately
#    and their order does not matter, but before each of them
#    (or the first of them) one leading dash must be specified.
#    Valid combinations: '-a -b -c', '-cba', '-b -ac'
# 2. Short arguments can have values and if are - value must go
#    next to argument itself.
#    Valid combinations: '-ab avalue', '-ba avalue', '-a avalue -b'
# 3. Long arguments cannot be combined like short ones and each
#    of them must be specified separately with two leading dashes.
#    Valid combinations: '--foo --bar', '--bar --foo'
# 4. Long arguments can have a value which must be specified after '='.
#    Valid combinations: '--foo=value --bar', '--bar --foo=value'
# 5. Values cannot contain spaces even in quotes both for short and
#    long args, otherwise first word will return as value.
# 6. You can use arg() or argl() to check presence of any arg, no matter
#    if it has value or not.

### USAGE ###
# This is simple examples which you can play around with.

# first we must save the original arguments passed
# to the script when it was called:
__MAIN_ARGS=$@

echo -e "\n1. Short args (vars):"
arg a 1 a  # -a
arg v 0 v  # -v v_value
arg c 1 c  # -c
arg z 1 z  # -z (not exists)
echo "1.1 a=$a"
echo "1.2 v=$v"
echo "1.3 c=$c"
echo "1.4 z=$z"

echo -e "\n2. Short args (echo):"
echo "2.1 a=$(arg a 1)"
echo "2.2 v=$(arg v 0)"
echo "2.3 c=$(arg c 1)"
echo "2.4 z=$(arg z 1)"

echo -e "\n3. Long args (vars):"
argl flag 1 flag # --flag
argl param1 0 param1 # --param1=test
argl param2 0 param2 # --param2=password
argl bar 1 bar   # --bar (not exists)
echo "3.1 flag=$flag"
echo "3.2 param1=$param1"
echo "3.3 param2=$param2"
echo "3.4 bar=$bar"

echo -e "\n4. Long args (echo):"
echo "4.1 flag=$(argl flag 1)"
echo "4.2 param1=$(argl param1 0)"
echo "4.3 param2=$(argl param2 0)"
echo "4.4 bar=$(argl bar 1)"

echo -e "\n5. Args by index:"
argn 1 first
echo "5.1 arg[1]=$first"
echo "5.2 arg[3]=$(argn 3)"

# Well, now we will try to get global args inside different functions

food() {
    echo -e "\n=== food() ==="
    arg f 0 food
    argl 'food' 0 food
    [ $food ] && echo "Om nom nom! $food is very tasty" || echo "Uh oh" >&2
}

hello() {
    echo -e "\n=== hello() ==="
    arg n 0 name
    argl name 0 name
    [ $name ] && echo "Hi, $name! How u r doin?" || echo "Hello, stranger..." >&2
}

hello
food

### OUTPUT ###

# Command to run:
# bash args.sh -va asdf --flag --param1=paramvalue1 -c --param2="somevalue2 sdf" --name="John" -f Seafood

# 1. Short args (vars):
# 1.1 a=1
# 1.2 v=v_value
# 1.3 c=1
# 1.4 z=
#
# 2. Short args (echo):
# 2.1 a=1
# 2.2 v=v_value
# 2.3 c=1
# 2.4 z=
#
# 3. Long args (vars):
# 3.1 longflag=1
# 3.2 param1=test
# 3.3 param2=password
# 3.4 barflag=
#
# 4. Long args (echo):
# 4.1 longflag=1
# 4.2 param1=test
# 4.3 param2=password
# 4.4 barflag=
#
# 5. Args by index:
# 5.1 arg[1]=asdf
# 5.2 arg[3]=--param1=paramvalue1
#
# === hello() ===
# Hi, John! How u r doin?
#
# === food() ===
# Om nom nom! Seafood is very tasty
