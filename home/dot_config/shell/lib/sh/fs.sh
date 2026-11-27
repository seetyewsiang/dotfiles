# shellcheck shell=sh

# @file fs.sh
# @brief Filesystem functions (file_ dir_ path_ glob_) for POSIX sh.
# @description
#   From https://github.com/dylanaraps/pure-sh-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print the first N lines of a file, like 'head -n N'.
#   Fix: the line counter is reset, so repeated calls work.
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
    i=0 # fix: reset the counter so repeated calls work
    while IFS= read -r line; do
        printf '%s\n' "$line"
        i=$((i+1))
        [ "$i" = "$1" ] && return
    done < "$2"
    [ -n "$line" ] && printf %s "$line"
}

# @description Print the number of lines in a file, like 'wc -l'. A last
#   line with no trailing newline still counts.
#   Fix: the counter is reset, so repeated calls work.
#
# @example
#   file_count_lines notes.txt
#   #=> 4
#
# @arg $1 path The file to count.
# @stdout The number of lines.
file_count_lines() {
    lines=0 # fix: reset the counter so repeated calls work
    while IFS= read -r line || [ -n "$line" ]; do
        lines=$((lines+1))
    done < "$1"
    printf '%s\n' "$lines"
}

# @description Print how many paths a glob matches. Prints 0 when nothing
#   matches. End the glob with / to count directories only.
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
    [ -e "$1" ] \
        && printf '%s\n' "$#" \
        || printf '%s\n' 0
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
    dir=${1:-.}
    dir=${dir%%"${dir##*[!/]}"}
    [ "${dir##*/*}" ] && dir=.
    dir=${dir%/*}
    dir=${dir%%"${dir##*[!/]}"}
    printf '%s\n' "${dir:-/}"
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
    dir=${1%${1##*[!/]}}
    dir=${dir##*/}
    dir=${dir%"$2"}
    printf '%s\n' "${dir:-/}"
}

# @description Print the absolute path of the folder holding the running
#   script. Symlinked folders on the way are resolved; a symlink to the
#   script file itself is not (you get the symlink's folder).
#
#   Uses $0, so it only works when the script is run, not sourced
#   (sh has no way to know which file is being sourced).
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
    case $0 in
        */*) dir=${0%/*} dir=${dir:-/} ;;
        *) dir=. ;;
    esac
    (cd -P -- "$dir" && pwd -P)
}

# @description Print a file line by line, like 'cat'. A last line with no
#   trailing newline is printed too. Use the loop as a template for
#   processing a file line by line.
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
    while IFS= read -r line || [ -n "$line" ]; do
        printf '%s\n' "$line"
    done < "$1"
}

# @description Read a key=value file and print each pair as "key: value".
#   Lines starting with # are skipped. Use the loop as a template for
#   loading config files.
#   Fix: a last line with no trailing newline is no longer dropped.
#
#   Source: wrapped from a bible snippet, not upstream code.
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
#   Source: wrapped from a bible snippet, not upstream code.
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
#   Source: wrapped from a bible snippet, not upstream code.
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
#   files are skipped, and symlinked directories are listed but not
#   entered.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    for file in "${1:-.}"/*; do
        [ -e "$file" ] || [ -L "$file" ] || continue
        printf '%s\n' "$file"
        if [ -d "$file" ] && [ ! -L "$file" ]; then
            dir_list_recursive "$file"
        fi
    done
}

# @description Print a whole file. Trailing blank lines are dropped.
#   Typical use: data=$(file_read file). Runs 'cat', as sh can't read a
#   file into a variable without it.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
file_read() {
    printf '%s\n' "$(cat -- "$1")"
}

# @description Print the last N lines of a file, like 'tail -n N'. Reads
#   the file twice: once to count, once to print.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    total=0
    while IFS= read -r line || [ -n "$line" ]; do
        total=$((total+1))
    done < "$2"
    i=0
    while IFS= read -r line || [ -n "$line" ]; do
        i=$((i+1))
        if [ "$i" -gt "$((total-$1))" ]; then printf '%s\n' "$line"; fi
    done < "$2"
}

# @description Print the number of lines in a file, using a read loop.
#   A last line with no trailing newline is not counted. Same as
#   file_count_lines here; kept so scripts can switch from bash.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
        count=$((count+1))
    done < "$1"
    printf '%s\n' "$count"
}

# @description Print the lines between two marker lines, not including
#   the markers. Each marker must match a whole line exactly.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
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
    extract=
    while IFS= read -r line; do
        if [ -n "$extract" ] && [ "$line" != "$3" ]; then
            printf '%s\n' "$line"
        fi
        case $line in
            "$2") extract=1 ;;
            "$3") extract= ;;
        esac
    done < "$1"
}
