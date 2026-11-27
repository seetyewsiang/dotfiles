# shellcheck shell=sh

# @file str.sh
# @brief String functions for POSIX sh.
# @description
#   From https://github.com/dylanaraps/pure-sh-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Remove a pattern from the start of a string.
#   The pattern is a shell glob; the longest match is removed.
#
# @example
#   str_lstrip "The Quick Brown Fox" "The "
#   #=> Quick Brown Fox
#   str_lstrip "v1.2.3" "v"
#   #=> 1.2.3
#
# @arg $1 string The input string.
# @arg $2 pattern Glob to remove from the start.
# @stdout The string without the matched prefix.
str_lstrip() {
    printf '%s\n' "${1##$2}"
}

# @description Remove a pattern from the end of a string.
#   The pattern is a shell glob; the longest match is removed.
#
# @example
#   str_rstrip "The Quick Brown Fox" " Fox"
#   #=> The Quick Brown
#   str_rstrip "report.tar.gz" ".*"
#   #=> report
#
# @arg $1 string The input string.
# @arg $2 pattern Glob to remove from the end.
# @stdout The string without the matched suffix.
str_rstrip() {
    printf '%s\n' "${1%%$2}"
}

# @description Remove leading and trailing whitespace. Inner spacing is kept.
#
# @example
#   str_trim "    Hello,  World    "
#   #=> Hello,  World
#
# @arg $1 string The input string.
# @stdout The trimmed string.
# @see str_trim_all
str_trim() {
    trim=${1#${1%%[![:space:]]*}}
    trim=${trim%${trim##*[![:space:]]}}
    printf '%s\n' "$trim"
}

# @description Remove leading and trailing whitespace, and squeeze inner
#   runs of whitespace to one space.
#
# @example
#   str_trim_all "    Hello,    World    "
#   #=> Hello, World
#
# @arg $1 string The input string.
# @stdout The trimmed, squeezed string.
# @see str_trim
# shellcheck disable=SC2086,SC2048
str_trim_all() {
    set -f
    set -- $*
    printf '%s\n' "$*"
    set +f
}

# @description Test whether a string contains a substring.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   str_contains "hello world" "lo w" && echo yes
#   #=> yes
#
# @arg $1 string The string to search.
# @arg $2 string The substring to look for.
# @exitcode 0 If the substring is found.
# @exitcode 1 If not.
str_contains() {
    case $1 in
        *"$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# @description Test whether a string starts with a prefix.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   str_starts_with "feature/login" "feature/" && echo yes
#   #=> yes
#
# @arg $1 string The string to check.
# @arg $2 string The prefix.
# @exitcode 0 If the string starts with the prefix.
# @exitcode 1 If not.
str_starts_with() {
    case $1 in
        "$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

# @description Test whether a string ends with a suffix.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   str_ends_with "photo.jpg" ".jpg" && echo yes
#   #=> yes
#
# @arg $1 string The string to check.
# @arg $2 string The suffix.
# @exitcode 0 If the string ends with the suffix.
# @exitcode 1 If not.
str_ends_with() {
    case $1 in
        *"$2") return 0 ;;
        *) return 1 ;;
    esac
}

# @description Split a string and print each field on its own line.
#   Every character of the delimiter is a separator (this uses IFS), so
#   ", " splits on commas and on spaces. The bash version treats the
#   delimiter as one whole string instead.
#
# @example
#   str_split "apples,oranges,pears" ","
#   #=> apples
#   #=> oranges
#   #=> pears
#   str_split "1, 2, 3" ", "
#   #=> 1
#   #=> 2
#   #=> 3
#
# @arg $1 string The string to split.
# @arg $2 string The separator characters.
# @stdout Each field, one per line.
str_split() {
    set -f
    old_ifs=$IFS
    IFS=$2
    # shellcheck disable=2086
    set -- $1
    printf '%s\n' "$@"
    IFS=$old_ifs
    set +f
}

# @description Remove every single and double quote from a string.
#
# @example
#   str_strip_quotes "'Hello', \"World\""
#   #=> Hello, World
#
# @arg $1 string The input string.
# @stdout The string without quotes.
str_strip_quotes() {
    set -f
    old_ifs=$IFS
    IFS=\"\'
    # shellcheck disable=2086
    set -- $1
    IFS=
    printf '%s\n' "$*"
    IFS=$old_ifs
    set +f
}

# @description Convert a string to lowercase.
#
#   Calls `tr`, the one sh function here that runs an external program
#   (POSIX sh has no built-in case conversion). Letters beyond A-Z are
#   converted only in a UTF-8 locale and only by a multibyte-aware `tr`
#   (macOS yes, GNU coreutils no).
#
#   Source: not in the pure-sh-bible; added here to match bash.
#
# @example
#   str_lower "HeLLo"
#   #=> hello
#
# @arg $1 string The input string.
# @stdout The lowercase string.
str_lower() {
    printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]'
}

# @description Convert a string to uppercase.
#
#   Calls `tr`; see str_lower for the locale caveat.
#
#   Source: not in the pure-sh-bible; added here to match bash.
#
# @example
#   str_upper "HeLLo"
#   #=> HELLO
#
# @arg $1 string The input string.
# @stdout The uppercase string.
str_upper() {
    printf '%s\n' "$1" | tr '[:lower:]' '[:upper:]'
}

# @description Swap the case of every letter. Runs 'tr'; only A-Z and
#   a-z are swapped.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   str_swap_case "HeLlO"
#   #=> hElLo
#
# @arg $1 string The input string.
# @stdout The string with each letter's case swapped.
str_swap_case() {
    printf '%s\n' "$1" | tr 'A-Za-z' 'a-zA-Z'
}

# @description Remove every match of a pattern anywhere in a string.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   str_strip_all "The Quick Brown Fox" "[aeiou]"
#   #=> Th Qck Brwn Fx
#   str_strip_all "The Quick Brown Fox" "[[:space:]]"
#   #=> TheQuickBrownFox
#
# @arg $1 string The input string.
# @arg $2 pattern Glob to remove everywhere.
# @stdout The string with every match removed.
# @see str_strip
str_strip_all() {
    rest=$1
    out=
    while :; do
        pre=${rest%%$2*}
        [ "$pre" = "$rest" ] && break
        match=${rest#"$pre"}
        after=${match##$2}
        out=$out$pre
        rest=$after
        [ "$after" = "$match" ] && break # empty match: stop
    done
    printf '%s\n' "$out$rest"
}

# @description Remove the first match of a pattern anywhere in a string.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   str_strip "The Quick Brown Fox" "[aeiou]"
#   #=> Th Quick Brown Fox
#
# @arg $1 string The input string.
# @arg $2 pattern Glob to remove once.
# @stdout The string with the first match removed.
# @see str_strip_all
str_strip() {
    pre=${1%%$2*}
    rest=${1#"$pre"}
    printf '%s\n' "$pre${rest##$2}"
}

# @description Percent-encode a string for use in a URL. Letters, digits
#   and . ~ _ - are kept; everything else becomes %XX.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   str_urlencode "a b&c/d"
#   #=> a%20b%26c%2Fd
#
# @arg $1 string The string to encode.
# @stdout The percent-encoded string.
# @see str_urldecode
str_urlencode() {
    ( # subshell, so LC_ALL=C stays local
        LC_ALL=C
        s=$1
        while [ -n "$s" ]; do
            rest=${s#?}
            c=${s%"$rest"}
            s=$rest
            case $c in
                [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
                *) printf '%%%02X' "'$c" ;;
            esac
        done
        printf '\n'
    )
}

# @description Decode a percent-encoded string. A + becomes a space.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   str_urldecode "a%20b%26c%2Fd+e"
#   #=> a b&c/d e
#
# @arg $1 string The string to decode.
# @stdout The decoded string.
# @see str_urlencode
str_urldecode() {
    s=$1
    out=
    while :; do
        case $s in
            *[+%]*) ;;
            *) break ;;
        esac
        pre=${s%%[+%]*}
        s=${s#"$pre"}
        case $s in
            +*)
                out="$out$pre "
                s=${s#+}
            ;;
            %[0-9A-Fa-f][0-9A-Fa-f]*)
                hex=${s#%}
                s=${hex#??}
                hex=${hex%"$s"}
                out="$out$pre\\0$(printf %o "0x$hex")"
            ;;
            *)
                out="$out$pre%"
                s=${s#%}
            ;;
        esac
    done
    printf '%b\n' "$out$s"
}
