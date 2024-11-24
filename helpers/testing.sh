#!/bin/bash
source $( dirname $(readlink -e -- "${BASH_SOURCE}"))/io.sh || exit 255

########################################################
# Testing functions
########################################################

# $1 - command to exec
assert_exec() {
    [ "$1" ] || exit 1
    local prefix="$(dt)${BOLD}${FWHITE}[TEST EXEC]"
    if $($1 1>/dev/null 2>&1); then
        local text="${BGREEN} PASSED"
    else
        local text="${BLRED} FAILED"
    fi
    print "${prefix} ${text} ${BRESET} ($?):${RESET} $1"
}
# usage:

# func1() {
#     return 0
# }
# func2() {
#     return 1
# }
# assert_exec "func1"  # PASSED
# assert_exec "func2"  # FAILED
# assert_exec "whoami" # PASSED


# $1 - command to exec
# $2 - expected output
assert_output() {
    [ "$1" ] || exit 1
    [ "$2" ] && local expected="$2" || local expected=''
    local prefix="$(dt)${BOLD}${FWHITE}[TEST OUTP]"
    local output=$($1 2>&1)
    local code=$?
    if [[ "$output" == *"$expected"* ]]; then
        local text="${BGREEN} PASSED"
    else
        local text="${BLRED} FAILED"
    fi
    print "${prefix} ${text} ${BRESET} (${code}|${expected}):${RESET} $1"
    # print "\tOutput > $output"
}
# usage:

# func1() {
#     echo "some string"
# }
# func2() {
#     echo "another string"
# }
# expect_output "func1" "string" # PASSED
# expect_output "func2" "some"   # FAILED
# expect_output "func2" "string" # PASSED


# $1 - command to exec
# $2 - expected exit-code
assert_code() {
    [ "$1" ] || exit 1
    [ "$2" ] && local expected=$2 || local expected=0
    local prefix="$(dt)${BOLD}${FWHITE}[TEST CODE]"
    $($1 1>/dev/null 2>&1)
    local code=$?
    if [[ $code -eq $expected ]]; then
        local text="${BGREEN} PASSED"
    else
        local text="${BLRED} FAILED"
    fi
    print "${prefix} ${text} ${BRESET} (${code}|${expected}):${RESET} $1"
}
# usage:

# func1() {
    # # exit 0
    # return 0
# }
# func2() {
    # # exit 1
    # return 1
# }
# expect_code "func1" 0 # PASSED
# expect_code "func1" 1 # FAILED
# expect_code "func2" 0 # FAILED
# expect_code "func2" 1 # PASSED
