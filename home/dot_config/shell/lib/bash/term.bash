# shellcheck shell=bash

# @file term.bash
# @brief Terminal functions for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print the terminal size as "lines columns".
#
# @example
#   term_size
#   #=> 40 120
#
# @noargs
# @stdout "LINES COLUMNS".
term_size() {
    shopt -s checkwinsize; (:;:)
    printf '%s\n' "$LINES $COLUMNS"
}

# @description Draw a progress bar on the current line. Call it
#   repeatedly with a rising percentage, then print a newline when done.
#
# @example
#   for p in 0 50 100; do term_progress_bar "$p" 10; sleep 0.2; done; echo
#   #=> [----------]
#
# @arg $1 int Percent done, 0-100.
# @arg $2 int Bar width in characters.
# @stdout The bar, ending in a carriage return.
term_progress_bar() {
    ((elapsed=$1*$2/100))
    printf -v prog  "%${elapsed}s"
    printf -v total "%$(($2-elapsed))s"
    printf '%s\r' "[${prog// /-}${total}]"
}

# @description Print the terminal window size in pixels. Prints just "x"
#   if the terminal does not answer. Works inside tmux.
#
# @example
#   term_window_size
#   #=> 1200x800
#
# @noargs
# @stdout "WIDTHxHEIGHT" in pixels.
term_window_size() {
    printf '%b' "${TMUX:+\\ePtmux;\\e}\\e[14t${TMUX:+\\e\\\\}"
    IFS=';t' read -d t -t 0.05 -sra term_size
    printf '%s\n' "${term_size[1]}x${term_size[2]}"
}

# @description Print the cursor position, both values starting at 1.
#
# @example
#   term_cursor_pos
#   #=> 1 8
#
# @noargs
# @stdout "COLUMN LINE".
term_cursor_pos() {
    IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
    printf '%s\n' "$x $y"
}
