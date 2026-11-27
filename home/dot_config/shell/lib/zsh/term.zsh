# shellcheck disable=all # shellcheck has no zsh support

# @file term.zsh
# @brief Terminal functions for zsh.
# @description
#   zsh versions of the functions in bash/term.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print the terminal size as "lines columns".
#
# @example
#   term_size
#   #=> 40 120
#
# @noargs
# @stdout "LINES COLUMNS".
term_size() {
    emulate -L zsh
    print -r -- "$LINES $COLUMNS"
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
    emulate -L zsh
    local elapsed prog total
    (( elapsed = $1 * $2 / 100 ))
    printf -v prog "%${elapsed}s"
    printf -v total "%$(( $2 - elapsed ))s"
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
    emulate -L zsh
    local -a size
    printf '%b' "${TMUX:+\\ePtmux;\\e}\\e[14t${TMUX:+\\e\\\\}"
    IFS=';t' read -d t -t 0.05 -s -r -A size
    print -r -- "${size[2]}x${size[3]}"
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
    emulate -L zsh
    local junk y x
    print -n $'\e[6n'
    IFS='[;' read -d R -s -r junk y x
    print -r -- "$x $y"
}
