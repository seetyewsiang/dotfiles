# shellcheck shell=bash

# @file var.bash
# @brief Variable functions for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
#   Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

# @description Assign a value to a variable whose name is in another
#   variable. Uses printf -v, so the variable is not local to this
#   function.
#
#   Source: wrapped from a bible snippet, not upstream code.
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
    printf -v "$1" '%s' "$2"
}

# @description Print the value of a variable whose name is in another
#   variable.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   hello_world=value; var_get hello_world
#   #=> value
#
# @arg $1 name Name of the variable to read.
# @stdout The variable's value.
# @see var_set
var_get() {
    printf '%s\n' "${!1}"
}

# @description Uppercase a variable in place, without a subshell. Pass the
#   variable's name, not its value.
#
#   Requires bash 4.3+.
#
# @example
#   foo=bar; var_to_upper foo; echo "$foo"
#   #=> BAR
#
# @arg $1 name Name of the variable to uppercase.
# @set $1 string The named variable, uppercased.
var_to_upper() {
    local -n ptr=${1}
    ptr=${ptr^^}
}
