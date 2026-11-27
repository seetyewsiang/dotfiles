# shellcheck disable=all # shellcheck has no zsh support

# @file str.zsh
# @brief String functions for zsh.
# @description
#   zsh versions of the functions in bash/str.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

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
    emulate -L zsh
    print -r -- "${1##${~2}}"
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
    emulate -L zsh
    print -r -- "${1%%${~2}}"
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
    emulate -L zsh
    setopt extended_glob
    print -r -- "${${1##[[:space:]]#}%%[[:space:]]#}"
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
    emulate -L zsh
    local -a words
    words=(${=1})
    print -r -- "${words[*]}"
}

# @description Test whether a string contains a substring.
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
    emulate -L zsh
    [[ $1 == *"$2"* ]]
}

# @description Test whether a string starts with a prefix.
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
    emulate -L zsh
    [[ $1 == "$2"* ]]
}

# @description Test whether a string ends with a suffix.
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
    emulate -L zsh
    [[ $1 == *"$2" ]]
}

# @description Split a string on a delimiter and print each field on its
#   own line. The delimiter is a whole string, so "---" splits on three
#   dashes.
#
# @example
#   str_split "apples,oranges,pears" ","
#   #=> apples
#   #=> oranges
#   #=> pears
#   str_split "hello---world" "---"
#   #=> hello
#   #=> world
#
# @arg $1 string The string to split.
# @arg $2 string The delimiter.
# @stdout Each field, one per line.
str_split() {
    emulate -L zsh
    print -rl -- ${(ps:$2:)1}
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
    emulate -L zsh
    local s=${1//\'/}
    print -r -- "${s//\"/}"
}

# @description Convert a string to lowercase.
#
# @example
#   str_lower "HeLLo"
#   #=> hello
#
# @arg $1 string The input string.
# @stdout The lowercase string.
str_lower() {
    emulate -L zsh
    print -r -- "${(L)1}"
}

# @description Convert a string to uppercase.
#
# @example
#   str_upper "HeLLo"
#   #=> HELLO
#
# @arg $1 string The input string.
# @stdout The uppercase string.
str_upper() {
    emulate -L zsh
    print -r -- "${(U)1}"
}

# @description Swap the case of every letter.
#
# @example
#   str_swap_case "HeLlO"
#   #=> hElLo
#
# @arg $1 string The input string.
# @stdout The string with each letter's case swapped.
str_swap_case() {
    emulate -L zsh
    local c out=
    for c in "${(@s::)1}"; do
        if [[ $c == [[:upper:]] ]]; then out+=${(L)c}; else out+=${(U)c}; fi
    done
    print -r -- "$out"
}

# @description Remove every match of a pattern anywhere in a string.
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
    emulate -L zsh
    print -r -- "${1//${~2}}"
}

# @description Remove the first match of a pattern anywhere in a string.
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
    emulate -L zsh
    print -r -- "${1/${~2}}"
}

# @description Percent-encode a string for use in a URL. Letters, digits
#   and . ~ _ - are kept; everything else becomes %XX.
#
# @example
#   str_urlencode "a b&c/d"
#   #=> a%20b%26c%2Fd
#
# @arg $1 string The string to encode.
# @stdout The percent-encoded string.
# @see str_urldecode
str_urlencode() {
    emulate -L zsh
    local LC_ALL=C c out=
    for c in "${(@s::)1}"; do
        case $c in
            [a-zA-Z0-9.~_-]) out+=$c ;;
            *) out+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    print -r -- "$out"
}

# @description Decode a percent-encoded string. A + becomes a space.
#
# @example
#   str_urldecode "a%20b%26c%2Fd+e"
#   #=> a b&c/d e
#
# @arg $1 string The string to decode.
# @stdout The decoded string.
# @see str_urlencode
str_urldecode() {
    emulate -L zsh
    local s=${1//+/ }
    printf '%b\n' "${s//\%/\\x}"
}

# @description Match a string against an extended regex and print the
#   first capture group.
#
# @example
#   str_regex "version 1.2.3" '([0-9]+\.[0-9]+)'
#   #=> 1.2
#   str_regex "    hello" '^[[:space:]]*(.*)'
#   #=> hello
#
# @arg $1 string The string to match.
# @arg $2 regex Extended regex with at least one capture group.
# @stdout The first capture group, if the regex matches.
# @exitcode 0 If the regex matches.
# @exitcode 1 If not.
str_regex() {
    emulate -L zsh
    [[ $1 =~ $2 ]] && print -r -- "$match[1]"
}
