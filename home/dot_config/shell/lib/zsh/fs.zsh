# shellcheck disable=all # shellcheck has no zsh support

# @file fs.zsh
# @brief File and directory functions for zsh.
# @description
#   zsh versions of the functions in bash/fs.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Print the first N lines of a file, like 'head -n N'.
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
    emulate -L zsh
    local i=0 line
    while (( i < $1 )) && IFS= read -r line; do
        print -r -- "$line"
        (( i++ ))
    done < "$2"
}

# @description Print the number of lines in a file, like 'wc -l'.
#
# @example
#   file_count_lines notes.txt
#   #=> 4
#
# @arg $1 path The file to count.
# @stdout The number of lines.
# @see file_count_lines_loop
file_count_lines() {
    emulate -L zsh
    local n=0 line
    while IFS= read -r line || [[ -n $line ]]; do
        (( n++ ))
    done < "$1"
    print -r -- "$n"
}

# @description Print how many paths a glob matches. End the glob with / to
#   count directories only. When nothing matches, zsh stops with "no
#   matches found" before the call; add (N) to the glob to get 0.
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
    emulate -L zsh
    print -r -- "$#"
}

# @description Create an empty file, or empty an existing one, like
#   ': > file'.
#
# @example
#   file_truncate out.log; [ -s out.log ] || echo empty
#   #=> empty
#
# @arg $1 path The file to create or empty.
file_truncate() {
    emulate -L zsh
    : >| "$1"
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
    emulate -L zsh
    local tmp=${1:-.}
    if [[ $tmp != *[!/]* ]]; then
        print /
        return
    fi
    tmp=${tmp%%"${tmp##*[!/]}"}
    if [[ $tmp != */* ]]; then
        print .
        return
    fi
    tmp=${tmp%/*}
    tmp=${tmp%%"${tmp##*[!/]}"}
    print -r -- "${tmp:-/}"
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
    emulate -L zsh
    local tmp
    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}
    print -r -- "${tmp:-/}"
}

# @description Print the absolute path of the folder holding the running
#   script. Symlinked folders on the way are resolved; a symlink to the
#   script file itself is not (you get the symlink's folder).
#
#   Uses $funcfiletrace (the file that called this function), so it also
#   works when the script is sourced.
#
# @example
#   script_dir=$(path_script_dir)    # in /opt/app/run.sh
#   #=> /opt/app
#
# @noargs
# @stdout The script's folder.
# @see path_dirname
path_script_dir() {
    emulate -L zsh
    local src=${funcfiletrace[1]%:*}
    [[ -n $src ]] || src=$ZSH_ARGZERO
    print -r -- "${${src:a:h}:P}"
}

# @description Print a file line by line; a template for processing a file
#   line by line. Leading and trailing whitespace on each line is dropped,
#   and so is a last line with no trailing newline.
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
    emulate -L zsh
    local line
    while read -r line; do
        print -r -- "$line"
    done < "$1"
}

# @description Read a key=value file and print each pair as "key: value".
#   Lines starting with # are skipped. Use the loop as a template for
#   loading config files.
#
# @example
#   file_parse_kv app.conf    # lines: "# comment", "name=demo", "port=8080"
#   #=> name: demo
#   #=> port: 8080
#
# @arg $1 path The file to read.
# @stdout One "key: value" line per pair.
file_parse_kv() {
    emulate -L zsh
    local key val
    while IFS='=' read -r key val || [[ -n $key ]]; do
        [[ -z $key || $key == \#* ]] && continue
        print -r -- "$key: $val"
    done < "$1"
}

# @description Print every entry in a directory, including broken
#   symlinks. Hidden files are skipped.
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
    emulate -L zsh
    local file
    for file in "${1:-.}"/*(N); do
        print -r -- "$file"
    done
}

# @description Print the subdirectories of a directory, each ending in /.
#
# @example
#   dir_list_dirs photos
#   #=> photos/2024/
#
# @arg $1 path The directory. Defaults to the current one.
# @stdout One directory path per line.
# @see dir_list
dir_list_dirs() {
    emulate -L zsh
    local dir
    for dir in "${1:-.}"/*(N-/); do
        print -r -- "$dir/"
    done
}

# @description Print every path under a directory, recursively. Hidden
#   files are skipped.
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
    emulate -L zsh
    local file
    for file in "${1:-.}"/**/*(N); do
        print -r -- "$file"
    done
}

# @description Print a whole file without starting 'cat'. Trailing blank
#   lines are dropped. Typical use: data=$(file_read file).
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
    emulate -L zsh
    print -r -- "$(<"$1")"
}

# @description Print the last N lines of a file, like 'tail -n N'.
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
    emulate -L zsh
    local -a lines
    local line
    while IFS= read -r line || [[ -n $line ]]; do
        lines+=("$line")
    done < "$2"
    (( $1 > 0 && ${#lines} )) && print -rl -- "${(@)lines[-$1,-1]}"
    return 0
}

# @description Print the number of lines in a file, using a read loop.
#   A last line with no trailing newline is not counted. Otherwise the
#   same as file_count_lines; kept so scripts can switch from bash.
#
# @example
#   file_count_lines_loop notes.txt
#   #=> 4
#
# @arg $1 path The file to count.
# @stdout The number of lines.
# @see file_count_lines
file_count_lines_loop() {
    emulate -L zsh
    local count=0 line
    while IFS= read -r line; do
        (( count++ ))
    done < "$1"
    print -r -- "$count"
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
    emulate -L zsh
    local line extract=
    while IFS= read -r line; do
        [[ -n $extract && $line != "$3" ]] && print -r -- "$line"
        [[ $line == "$2" ]] && extract=1
        [[ $line == "$3" ]] && extract=
    done < "$1"
    return 0
}

# @description Read a file into an array, one element per line. Pass the
#   array's name, not "${arr[@]}".
#
# @example
#   file_read_array lines notes.txt; echo "${#lines[@]} ${lines[1]}"
#   #=> 4 line 1
#
# @arg $1 name Name of the array to fill.
# @arg $2 path The file to read.
# @set $1 array The named array, one line per element.
# @see file_read
file_read_array() {
    emulate -L zsh
    # Odd local names, so they can't hide the caller's array.
    local -a __fra_lines
    local __fra_line
    while IFS= read -r __fra_line || [[ -n $__fra_line ]]; do
        __fra_lines+=("$__fra_line")
    done < "$2"
    set -A "$1" "${(@)__fra_lines}"
}
