# shellcheck shell=sh

# @file term.sh
# @brief Terminal functions for POSIX sh.
# @description
#   Ported from https://github.com/dylanaraps/pure-bash-bible
#   (MIT); the pure-sh-bible has no terminal functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print the terminal size as "lines columns". Runs
#   'stty size', which macOS, Linux and the BSDs have but POSIX doesn't
#   require.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   term_size
#   #=> 40 120
#
# @noargs
# @stdout "LINES COLUMNS".
term_size() {
    stty size < /dev/tty
}

# @description Draw a progress bar on the current line. Call it
#   repeatedly with a rising percentage, then print a newline when done.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   for p in 0 50 100; do term_progress_bar "$p" 10; sleep 0.2; done; echo
#   #=> [----------]
#
# @arg $1 int Percent done, 0-100.
# @arg $2 int Bar width in characters.
# @stdout The bar, ending in a carriage return.
term_progress_bar() {
    elapsed=$(($1*$2/100))
    bar=
    i=0
    while [ "$i" -lt "$2" ]; do
        if [ "$i" -lt "$elapsed" ]; then bar="$bar-"; else bar="$bar "; fi
        i=$((i+1))
    done
    printf '%s\r' "[$bar]"
}
