# shellcheck shell=bash

# @file num.bash
# @brief Number functions for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print every integer from start to end, inclusive.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   num_range 3 5
#   #=> 3
#   #=> 4
#   #=> 5
#
# @arg $1 int First number.
# @arg $2 int Last number.
# @stdout Each integer, one per line.
num_range() {
    for ((i=$1;i<=$2;i++)); do
        printf '%s\n' "$i"
    done
}

# @description Print the larger of two integers.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   num_max 3 7
#   #=> 7
#
# @arg $1 int First number.
# @arg $2 int Second number.
# @stdout The larger number.
num_max() {
    printf '%s\n' "$(($1>$2?$1:$2))"
}

# @description Test whether a value is a decimal number with a dot, like
#   1.5. Whole numbers do not count.
#
#   Source: from the pure-sh-bible (same code as the sh version).
#
# @example
#   num_is_float 1.5 && echo yes
#   #=> yes
#   num_is_float 2 || echo no
#   #=> no
#
# @arg $1 string The value to test.
# @exitcode 0 If it is a decimal number.
# @exitcode 1 If not.
num_is_float() {
    [ -z "${1##*.*}" ] &&
        printf %f "$1" >/dev/null 2>&1
}

# @description Test whether a value is a whole number, optionally signed.
#   Fix: a digits-only check was added, because zsh's printf %d accepts 1.1.
#
#   Source: from the pure-sh-bible (same code as the sh version).
#
# @example
#   num_is_int -42 && echo yes
#   #=> yes
#   num_is_int 1.1 || echo no
#   #=> no
#
# @arg $1 string The value to test.
# @exitcode 0 If it is a whole number.
# @exitcode 1 If not.
num_is_int() {
    case ${1#[-+]} in
        '' | *[!0-9]*) return 1 ;;
    esac
    printf %d "$1" >/dev/null 2>&1
}
