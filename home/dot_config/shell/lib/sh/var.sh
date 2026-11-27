# shellcheck shell=sh

# @file var.sh
# @brief Variable functions for POSIX sh.
# @description
#   From https://github.com/dylanaraps/pure-sh-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Assign a value to a variable whose name is in another
#   variable. The name goes through eval: only pass trusted, valid names.
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
    eval "$1=\$2"
}

# @description Print the value of a variable whose name is in another
#   variable. The name goes through eval: only pass trusted, valid names.
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
    eval printf '%s\\n' "\"\$$1\""
}

# @description Uppercase a variable in place. Pass the variable's name,
#   not its value. The name goes through eval: only pass trusted, valid
#   names. Runs 'tr' (see str_upper); trailing newlines in the value are
#   dropped.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   foo=bar; var_to_upper foo; echo "$foo"
#   #=> BAR
#
# @arg $1 name Name of the variable to uppercase.
# @set $1 string The named variable, uppercased.
var_to_upper() {
    eval "$1=\$(printf '%s\n' \"\$$1\" | tr '[:lower:]' '[:upper:]')"
}
