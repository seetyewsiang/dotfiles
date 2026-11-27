# shellcheck shell=sh

# @file color.sh
# @brief Color functions for POSIX sh.
# @description
#   Ported from https://github.com/dylanaraps/pure-bash-bible
#   (MIT); the pure-sh-bible has no color functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Check a hex color like #fff or #A1B2C3 (the # is optional).
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    hex=${1#\#}
    case ${#hex} in
        3 | 6) ;;
        *) hex=x ;;
    esac
    case $hex in
        *[!0-9a-fA-F]*)
            printf '%s\n' "error: $1 is an invalid color."
            return 1
        ;;
    esac
    printf '%s\n' "$1"
}

# @description Convert a six-digit hex color to decimal R G B values.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    hex=${1#\#}
    r=$((0x${hex%????}))
    g=${hex#??}
    g=$((0x${g%??}))
    b=$((0x${hex#????}))
    printf '%s\n' "$r $g $b"
}

# @description Convert decimal R G B values to a lowercase hex color.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    printf '#%02x%02x%02x\n' "$1" "$2" "$3"
}
