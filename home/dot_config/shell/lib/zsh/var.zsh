# shellcheck disable=all # shellcheck has no zsh support

# @file var.zsh
# @brief Variable functions for zsh.
# @description
#   zsh versions of the functions in bash/var.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Assign a value to a variable whose name is in another
#   variable. Uses ${(P)name::=value}, so the variable is not local to
#   this function.
#
# @example
#   suffix=world; var_set "hello_$suffix" value; echo "$hello_world"
#   #=> value
#
# @arg $1 name Name of the variable to set.
# @arg $2 string The value.
# @set $1 string The named variable.
# @see var_get
var_set() {
    emulate -L zsh
    : ${(P)1::="$2"}
}

# @description Print the value of a variable whose name is in another
#   variable.
#
# @example
#   hello_world=value; var_get hello_world
#   #=> value
#
# @arg $1 name Name of the variable to read.
# @stdout The variable's value.
# @see var_set
var_get() {
    emulate -L zsh
    print -r -- "${(P)1}"
}

# @description Uppercase a variable in place, without a subshell. Pass the
#   variable's name, not its value.
#
# @example
#   foo=bar; var_to_upper foo; echo "$foo"
#   #=> BAR
#
# @arg $1 name Name of the variable to uppercase.
# @set $1 string The named variable, uppercased.
var_to_upper() {
    emulate -L zsh
    : ${(P)1::="${(U)${(P)1}}"}
}
