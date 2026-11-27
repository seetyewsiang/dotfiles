# shellcheck shell=sh

# @file arr.sh
# @brief Array functions for POSIX sh. sh has no arrays, so each function takes the elements as arguments.
# @description
#   Ported from https://github.com/dylanaraps/pure-bash-bible
#   (MIT); the pure-sh-bible has no array functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Test whether any element contains a substring.
#   The elements are joined with spaces first, so a match can also span
#   two elements ("d b" matches red blue).
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   arr_contains blue red blue green && echo yes
#   #=> yes
#
# @arg $1 string The substring to look for.
# @arg $@ string The elements, as "$@".
# @exitcode 0 If found.
# @exitcode 1 If not.
arr_contains() {
    needle=$1
    shift
    case "$*" in
        *"$needle"*) return 0 ;;
    esac
    return 1
}

# @description Print the elements in reverse order, one per line.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   arr_reverse red blue green
#   #=> green
#   #=> blue
#   #=> red
#
# @arg $@ string The elements, as "$@".
# @stdout The elements in reverse order, one per line.
arr_reverse() {
    i=$#
    while [ "$i" -gt 0 ]; do
        eval "printf '%s\n' \"\${$i}\""
        i=$((i-1))
    done
}

# @description Print the elements with duplicates removed, one per line,
#   in the order they first appear. Empty elements are skipped.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   arr_dedupe red red green blue blue
#   #=> red
#   #=> green
#   #=> blue
#
# @arg $@ string The elements, as "$@".
# @stdout Each distinct element, one per line.
arr_dedupe() {
    seen='
'
    for i do
        [ -n "$i" ] || continue
        case "$seen" in
            *"
$i
"*) continue ;;
        esac
        seen="$seen$i
"
        printf '%s\n' "$i"
    done
}

# @description Print one element chosen at random. Reads /dev/urandom
#   with 'od', as sh has no $RANDOM.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   arr_random red green blue
#   #=> green
#
# @arg $@ string The elements, as "$@".
# @stdout One random element.
arr_random() {
    for n in $(od -An -N4 -tu4 /dev/urandom); do :; done # trims od's padding
    shift $((n % $#))
    printf '%s\n' "$1"
}
