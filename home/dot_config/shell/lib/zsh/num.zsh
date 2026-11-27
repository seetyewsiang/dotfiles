# shellcheck disable=all # shellcheck has no zsh support

# @file num.zsh
# @brief Number functions for zsh.
# @description
#   zsh versions of the functions in bash/num.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print every integer from start to end, inclusive.
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
    emulate -L zsh
    local i
    for (( i = $1; i <= $2; i++ )); do
        print -r -- "$i"
    done
}

# @description Print the larger of two integers.
#
# @example
#   num_max 3 7
#   #=> 7
#
# @arg $1 int First number.
# @arg $2 int Second number.
# @stdout The larger number.
num_max() {
    emulate -L zsh
    print -r -- "$(( $1 > $2 ? $1 : $2 ))"
}

# @description Test whether a value is a decimal number with a dot, like
#   1.5. Whole numbers do not count.
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
    emulate -L zsh
    [[ $1 == *.* ]] &&
        printf %f "$1" >/dev/null 2>&1
}

# @description Test whether a value is a whole number, optionally signed.
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
    emulate -L zsh
    [[ $1 == ([-+]|)<-> ]]
}
