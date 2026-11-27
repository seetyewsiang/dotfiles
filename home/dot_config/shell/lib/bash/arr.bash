# shellcheck shell=bash

# @file arr.bash
# @brief Array functions for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
#   Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

# @description Test whether any array element contains a substring.
#   The elements are joined with spaces first, so a match can also span
#   two elements ("d b" matches red blue).
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   arr_contains blue red blue green && echo yes
#   #=> yes
#
# @arg $1 string The substring to look for.
# @arg $@ string The array elements, as "${arr[@]}".
# @exitcode 0 If found.
# @exitcode 1 If not.
arr_contains() {
    local needle=$1
    shift
    [[ $* == *"$needle"* ]]
}

# @description Print the elements in reverse order, one per line.
#   Note: it reads BASH_ARGV, so when called from a file that was itself
#   sourced with arguments, it prints those arguments too.
#
# @example
#   arr_reverse red blue green
#   #=> green
#   #=> blue
#   #=> red
#
# @arg $@ string The array elements, as "${arr[@]}".
# @stdout The elements in reverse order, one per line.
arr_reverse() {
    shopt -s extdebug
    f()(printf '%s\n' "${BASH_ARGV[@]}"); f "$@"
    shopt -u extdebug
}

# @description Print the elements with duplicates removed, one per line.
#   Uses an associative array, so the output order is not guaranteed.
#
#   Requires bash 4+.
#
# @example
#   arr_dedupe red red green blue blue
#   #=> red
#   #=> green
#   #=> blue
#
# @arg $@ string The array elements, as "${arr[@]}".
# @stdout Each distinct element, one per line.
arr_dedupe() {
    declare -A tmp_array
    for i in "$@"; do
        [[ $i ]] && IFS=" " tmp_array["${i:- }"]=1
    done
    printf '%s\n' "${!tmp_array[@]}"
}

# @description Print one element chosen at random.
#
# @example
#   arr_random red green blue
#   #=> green
#
# @arg $@ string The array elements, as "${arr[@]}".
# @stdout One random element.
arr_random() {
    local arr=("$@")
    printf '%s\n' "${arr[RANDOM % $#]}"
}

# @description Print the next element of the global array 'arr' on each
#   call, followed by a space, wrapping around at the end. For a toggle,
#   set arr=(true false).
#
# @example
#   arr=(a b c); arr_cycle; arr_cycle; arr_cycle; arr_cycle; echo
#   #=> a b c a
#
# @noargs
# @stdout The next element of arr, followed by a space.
# @set i int Position of the next element (global).
arr_cycle() {
    printf '%s ' "${arr[${i:=0}]}"
    ((i=i>=${#arr[@]}-1?0:++i))
}
