# shellcheck shell=bash

# @file fs.bash
# @brief Filesystem functions (file_ dir_ path_ glob_) for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
#   Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

# @description Print the first N lines of a file, like 'head -n N'.
#
#   Requires bash 4+.
#
# @example
#   file_head 2 notes.txt     # notes.txt holds "line 1" to "line 4"
#   #=> line 1
#   #=> line 2
#
# @arg $1 int Number of lines.
# @arg $2 path The file to read.
# @stdout The first N lines.
# @see file_tail
file_head() {
    mapfile -tn "$1" line < "$2"
    printf '%s\n' "${line[@]}"
}

# @description Print the number of lines in a file, like 'wc -l'.
#
#   Requires bash 4+.
#
# @example
#   file_count_lines notes.txt
#   #=> 4
#
# @arg $1 path The file to count.
# @stdout The number of lines.
# @see file_count_lines_loop
file_count_lines() {
    mapfile -tn 0 lines < "$1"
    printf '%s\n' "${#lines[@]}"
}

# @description Print how many paths a glob matches. End the glob with / to
#   count directories only. When nothing matches it prints 1 (bash passes
#   the unexpanded glob), unless 'shopt -s nullglob' is on.
#
# @example
#   glob_count photos/*       # photos/ holds a.jpg, b.jpg, 2024/
#   #=> 3
#   glob_count photos/*/
#   #=> 1
#
# @arg $@ path An unquoted glob, such as dir/* or dir/*/.
# @stdout The number of matches.
glob_count() {
    printf '%s\n' "$#"
}

# @description Create an empty file, or empty an existing one, like
#   ': > file'.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   file_truncate out.log; [ -s out.log ] || echo empty
#   #=> empty
#
# @arg $1 path The file to create or empty.
file_truncate() {
    :>"$1"
}

# @description Print the directory part of a path, like the 'dirname'
#   command.
#
# @example
#   path_dirname /home/me/photos/1.jpg
#   #=> /home/me/photos
#   path_dirname /home/me/photos/
#   #=> /home/me
#
# @arg $1 path The path.
# @stdout The parent directory.
# @see path_basename
path_dirname() {
    local tmp=${1:-.}
    [[ $tmp != *[!/]* ]] && {
        printf '/\n'
        return
    }
    tmp=${tmp%%"${tmp##*[!/]}"}
    [[ $tmp != */* ]] && {
        printf '.\n'
        return
    }
    tmp=${tmp%/*}
    tmp=${tmp%%"${tmp##*[!/]}"}
    printf '%s\n' "${tmp:-/}"
}

# @description Print the last part of a path, like the 'basename'
#   command, optionally removing a suffix.
#
# @example
#   path_basename /home/me/photos/1.jpg
#   #=> 1.jpg
#   path_basename /home/me/photos/1.jpg .jpg
#   #=> 1
#
# @arg $1 path The path.
# @arg $2 string Optional suffix to remove.
# @stdout The last path component.
# @see path_dirname
path_basename() {
    local tmp
    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}
    printf '%s\n' "${tmp:-/}"
}

# @description Print the absolute path of the folder holding the running
#   script. Symlinked folders on the way are resolved; a symlink to the
#   script file itself is not (you get the symlink's folder).
#
#   Uses BASH_SOURCE, so it also works when the script is sourced.
#
#   Source: written here, not in the bibles.
#
# @example
#   script_dir=$(path_script_dir)    # in /opt/app/run.sh
#   #=> /opt/app
#
# @noargs
# @stdout The script's folder.
# @see path_dirname
path_script_dir() {
    local src=${BASH_SOURCE[1]:-$0} dir
    case $src in
        */*) dir=${src%/*} dir=${dir:-/} ;;
        *) dir=. ;;
    esac
    (cd -P -- "$dir" && pwd -P)
}

# @description Print a file line by line; a template for processing a file
#   line by line. Leading and trailing whitespace on each line is dropped,
#   and so is a last line with no trailing newline.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   file_print_lines notes.txt
#   #=> line 1
#   #=> line 2
#   #=> line 3
#   #=> line 4
#
# @arg $1 path The file to read.
# @stdout Every line of the file.
file_print_lines() {
    while read -r line; do
        printf '%s\n' "$line"
    done < "$1"
}

# @description Read a key=value file and print each pair as "key: value".
#   Lines starting with # are skipped. Use the loop as a template for
#   loading config files.
#   Fix: a last line with no trailing newline is no longer dropped.
#
#
#   Source: from the pure-sh-bible (same code as the sh version).
#
# @example
#   file_parse_kv app.conf    # lines: "# comment", "name=demo", "port=8080"
#   #=> name: demo
#   #=> port: 8080
#
# @arg $1 path The file to read.
# @stdout One "key: value" line per pair.
file_parse_kv() {
    while IFS='=' read -r key val || [ -n "$key" ]; do
        [ "${key##\#*}" ] || continue
        printf '%s: %s\n' "$key" "$val"
    done < "$1"
}

# @description Print every entry in a directory, including broken
#   symlinks. Hidden files are skipped.
#
#
#   Source: from the pure-sh-bible (same code as the sh version).
#
# @example
#   dir_list photos
#   #=> photos/2024
#   #=> photos/a.jpg
#   #=> photos/b.jpg
#
# @arg $1 path The directory. Defaults to the current one.
# @stdout One path per line.
# @see dir_list_dirs
dir_list() {
    for file in "${1:-.}"/*; do
        [ -e "$file" ] || [ -L "$file" ] || continue
        printf '%s\n' "$file"
    done
}

# @description Print the subdirectories of a directory, each ending in /.
#
#
#   Source: from the pure-sh-bible (same code as the sh version).
#
# @example
#   dir_list_dirs photos
#   #=> photos/2024/
#
# @arg $1 path The directory. Defaults to the current one.
# @stdout One directory path per line.
# @see dir_list
dir_list_dirs() {
    for dir in "${1:-.}"/*/; do
        [ -d "$dir" ] || continue
        printf '%s\n' "$dir"
    done
}

# @description Print every path under a directory, recursively. Hidden
#   files are skipped.
#
#   Requires bash 4+.
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   dir_list_recursive photos
#   #=> photos/2024
#   #=> photos/2024/c.jpg
#   #=> photos/a.jpg
#   #=> photos/b.jpg
#
# @arg $1 path The directory. Defaults to the current one.
# @stdout One path per line.
dir_list_recursive() {
    shopt -s globstar
    for file in "${1:-.}"/**/*; do
        printf '%s\n' "$file"
    done
    shopt -u globstar
}

# @description Print a whole file without starting 'cat'. Trailing blank
#   lines are dropped. Typical use: data=$(file_read file).
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   file_read notes.txt
#   #=> line 1
#   #=> line 2
#   #=> line 3
#   #=> line 4
#
# @arg $1 path The file to read.
# @stdout The file's contents.
# @see file_read_array
file_read() {
    printf '%s\n' "$(<"$1")"
}

# @description Print the last N lines of a file, like 'tail -n N'.
#
#   Requires bash 4+.
#
# @example
#   file_tail 2 notes.txt
#   #=> line 3
#   #=> line 4
#
# @arg $1 int Number of lines.
# @arg $2 path The file to read.
# @stdout The last N lines.
# @see file_head
file_tail() {
    mapfile -tn 0 line < "$2"
    printf '%s\n' "${line[@]: -$1}"
}

# @description Print the number of lines in a file, using a read loop.
#   Works on bash 3.2, unlike file_count_lines. Slower on big files, and a
#   last line with no trailing newline is not counted.
#
# @example
#   file_count_lines_loop notes.txt
#   #=> 4
#
# @arg $1 path The file to count.
# @stdout The number of lines.
# @see file_count_lines
file_count_lines_loop() {
    count=0
    while IFS= read -r _; do
        ((count++))
    done < "$1"
    printf '%s\n' "$count"
}

# @description Print the lines between two marker lines, not including
#   the markers. Each marker must match a whole line exactly.
#
# @example
#   file_extract_between doc.md "<!-- start -->" "<!-- end -->"
#   #=> keep me
#
# @arg $1 path The file to read.
# @arg $2 string The opening marker line.
# @arg $3 string The closing marker line.
# @stdout The lines between the markers.
file_extract_between() {
    while IFS=$'\n' read -r line; do
        [[ $extract && $line != "$3" ]] &&
            printf '%s\n' "$line"
        [[ $line == "$2" ]] && extract=1
        [[ $line == "$3" ]] && extract=
    done < "$1"
}

# @description Read a file into an array, one element per line. Pass the
#   array's name, not "${arr[@]}".
#
#   Requires bash 4+.
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   file_read_array lines notes.txt; echo "${#lines[@]} ${lines[0]}"
#   #=> 4 line 1
#
# @arg $1 name Name of the array to fill.
# @arg $2 path The file to read.
# @set $1 array The named array, one line per element.
# @see file_read
file_read_array() {
    mapfile -t "$1" < "$2"
}
