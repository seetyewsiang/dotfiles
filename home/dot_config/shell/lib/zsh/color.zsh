# shellcheck disable=all # shellcheck has no zsh support

# @file color.zsh
# @brief Color functions for zsh.
# @description
#   zsh versions of the functions in bash/color.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Check a hex color like #fff or #A1B2C3 (the # is optional).
#
# @example
#   color_is_hex "#FFFFFF"
#   #=> #FFFFFF
#   color_is_hex red
#   #=> error: red is an invalid color.
#
# @arg $1 string The color to check.
# @stdout The color if valid, else an error message.
# @exitcode 0 If the color is valid.
# @exitcode 1 If not.
color_is_hex() {
    emulate -L zsh
    if [[ $1 =~ '^(#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3}))$' ]]; then
        print -r -- "$match[1]"
    else
        print -r -- "error: $1 is an invalid color."
        return 1
    fi
}

# @description Convert a six-digit hex color to decimal R G B values.
#
# @example
#   color_hex_to_rgb "#FF8000"
#   #=> 255 128 0
#
# @arg $1 string Hex color, #RRGGBB or RRGGBB.
# @stdout "R G B" as decimal numbers.
# @set r int Red value (global).
# @set g int Green value (global).
# @set b int Blue value (global).
# @see color_rgb_to_hex
color_hex_to_rgb() {
    emulate -L zsh
    local hex=${1#\#}
    r=$(( 16#${hex[1,2]} )) g=$(( 16#${hex[3,4]} )) b=$(( 16#${hex[5,6]} ))
    print -r -- "$r $g $b"
}

# @description Convert decimal R G B values to a lowercase hex color.
#
# @example
#   color_rgb_to_hex 255 128 0
#   #=> #ff8000
#
# @arg $1 int Red, 0-255.
# @arg $2 int Green, 0-255.
# @arg $3 int Blue, 0-255.
# @stdout The color as #rrggbb.
# @see color_hex_to_rgb
color_rgb_to_hex() {
    emulate -L zsh
    printf '#%02x%02x%02x\n' "$1" "$2" "$3"
}
