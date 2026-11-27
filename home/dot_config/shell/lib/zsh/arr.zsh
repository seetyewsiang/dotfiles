# shellcheck disable=all # shellcheck has no zsh support

# @file arr.zsh
# @brief Array functions for zsh.
# @description
#   zsh versions of the functions in bash/arr.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Test whether any array element contains a substring.
#   The elements are joined with spaces first, so a match can also span
#   two elements ("d b" matches red blue).
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
    emulate -L zsh
    local needle=$1
    shift
    [[ "$*" == *"$needle"* ]]
}

# @description Print the elements in reverse order, one per line.
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
    emulate -L zsh
    print -rl -- "${(@Oa)@}"
}

# @description Print the elements with duplicates removed, one per line.
#   Keeps the order they first appear in; empty elements are skipped.
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
    emulate -L zsh
    print -rl -- ${(u)@}
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
    emulate -L zsh
    print -r -- "${@[RANDOM % $# + 1]}"
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
    emulate -L zsh
    printf '%s ' "${arr[${i:=0} + 1]}"
    (( i = i >= ${#arr} - 1 ? 0 : i + 1 ))
}
