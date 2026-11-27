# fs.bash

Filesystem functions (file_ dir_ path_ glob_) for bash.

## Overview

From https://github.com/dylanaraps/pure-bash-bible
(MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

## Index

* [file_head](#file_head)
* [file_count_lines](#file_count_lines)
* [glob_count](#glob_count)
* [file_truncate](#file_truncate)
* [path_dirname](#path_dirname)
* [path_basename](#path_basename)
* [path_script_dir](#path_script_dir)
* [file_print_lines](#file_print_lines)
* [file_parse_kv](#file_parse_kv)
* [dir_list](#dir_list)
* [dir_list_dirs](#dir_list_dirs)
* [dir_list_recursive](#dir_list_recursive)
* [file_read](#file_read)
* [file_tail](#file_tail)
* [file_count_lines_loop](#file_count_lines_loop)
* [file_extract_between](#file_extract_between)
* [file_read_array](#file_read_array)

### file_head

Print the first N lines of a file, like 'head -n N'.

Requires bash 4+.

#### Example

```bash
file_head 2 notes.txt     # notes.txt holds "line 1" to "line 4"
#=> line 1
#=> line 2
```

#### Arguments

* **$1** (int): Number of lines.
* **$2** (path): The file to read.

#### Output on stdout

* The first N lines.

#### See also

* [file_tail](#file_tail)

### file_count_lines

Print the number of lines in a file, like 'wc -l'.

Requires bash 4+.

#### Example

```bash
file_count_lines notes.txt
#=> 4
```

#### Arguments

* **$1** (path): The file to count.

#### Output on stdout

* The number of lines.

#### See also

* [file_count_lines_loop](#file_count_lines_loop)

### glob_count

Print how many paths a glob matches. End the glob with / to
count directories only. When nothing matches it prints 1 (bash passes
the unexpanded glob), unless 'shopt -s nullglob' is on.

#### Example

```bash
glob_count photos/*       # photos/ holds a.jpg, b.jpg, 2024/
#=> 3
glob_count photos/*/
#=> 1
```

#### Arguments

* **...** (path): An unquoted glob, such as dir/* or dir/*/.

#### Output on stdout

* The number of matches.

### file_truncate

Create an empty file, or empty an existing one, like
': > file'.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
file_truncate out.log; [ -s out.log ] || echo empty
#=> empty
```

#### Arguments

* **$1** (path): The file to create or empty.

### path_dirname

Print the directory part of a path, like the 'dirname'
command.

#### Example

```bash
path_dirname /home/me/photos/1.jpg
#=> /home/me/photos
path_dirname /home/me/photos/
#=> /home/me
```

#### Arguments

* **$1** (path): The path.

#### Output on stdout

* The parent directory.

#### See also

* [path_basename](#path_basename)

### path_basename

Print the last part of a path, like the 'basename'
command, optionally removing a suffix.

#### Example

```bash
path_basename /home/me/photos/1.jpg
#=> 1.jpg
path_basename /home/me/photos/1.jpg .jpg
#=> 1
```

#### Arguments

* **$1** (path): The path.
* **$2** (string): Optional suffix to remove.

#### Output on stdout

* The last path component.

#### See also

* [path_dirname](#path_dirname)

### path_script_dir

Print the absolute path of the folder holding the running
script. Symlinked folders on the way are resolved; a symlink to the
script file itself is not (you get the symlink's folder).

Uses BASH_SOURCE, so it also works when the script is sourced.

Source: written here, not in the bibles.

#### Example

```bash
script_dir=$(path_script_dir)    # in /opt/app/run.sh
#=> /opt/app
```

_Function has no arguments._

#### Output on stdout

* The script's folder.

#### See also

* [path_dirname](#path_dirname)

### file_print_lines

Print a file line by line; a template for processing a file
line by line. Leading and trailing whitespace on each line is dropped,
and so is a last line with no trailing newline.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
file_print_lines notes.txt
#=> line 1
#=> line 2
#=> line 3
#=> line 4
```

#### Arguments

* **$1** (path): The file to read.

#### Output on stdout

* Every line of the file.

### file_parse_kv

Read a key=value file and print each pair as "key: value".
Lines starting with # are skipped. Use the loop as a template for
loading config files.
Fix: a last line with no trailing newline is no longer dropped.


Source: from the pure-sh-bible (same code as the sh version).

#### Example

```bash
file_parse_kv app.conf    # lines: "# comment", "name=demo", "port=8080"
#=> name: demo
#=> port: 8080
```

#### Arguments

* **$1** (path): The file to read.

#### Output on stdout

* One "key: value" line per pair.

### dir_list

Print every entry in a directory, including broken
symlinks. Hidden files are skipped.


Source: from the pure-sh-bible (same code as the sh version).

#### Example

```bash
dir_list photos
#=> photos/2024
#=> photos/a.jpg
#=> photos/b.jpg
```

#### Arguments

* **$1** (path): The directory. Defaults to the current one.

#### Output on stdout

* One path per line.

#### See also

* [dir_list_dirs](#dir_list_dirs)

### dir_list_dirs

Print the subdirectories of a directory, each ending in /.


Source: from the pure-sh-bible (same code as the sh version).

#### Example

```bash
dir_list_dirs photos
#=> photos/2024/
```

#### Arguments

* **$1** (path): The directory. Defaults to the current one.

#### Output on stdout

* One directory path per line.

#### See also

* [dir_list](#dir_list)

### dir_list_recursive

Print every path under a directory, recursively. Hidden
files are skipped.

Requires bash 4+.
Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
dir_list_recursive photos
#=> photos/2024
#=> photos/2024/c.jpg
#=> photos/a.jpg
#=> photos/b.jpg
```

#### Arguments

* **$1** (path): The directory. Defaults to the current one.

#### Output on stdout

* One path per line.

### file_read

Print a whole file without starting 'cat'. Trailing blank
lines are dropped. Typical use: data=$(file_read file).

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
file_read notes.txt
#=> line 1
#=> line 2
#=> line 3
#=> line 4
```

#### Arguments

* **$1** (path): The file to read.

#### Output on stdout

* The file's contents.

#### See also

* [file_read_array](#file_read_array)

### file_tail

Print the last N lines of a file, like 'tail -n N'.

Requires bash 4+.

#### Example

```bash
file_tail 2 notes.txt
#=> line 3
#=> line 4
```

#### Arguments

* **$1** (int): Number of lines.
* **$2** (path): The file to read.

#### Output on stdout

* The last N lines.

#### See also

* [file_head](#file_head)

### file_count_lines_loop

Print the number of lines in a file, using a read loop.
Works on bash 3.2, unlike file_count_lines. Slower on big files, and a
last line with no trailing newline is not counted.

#### Example

```bash
file_count_lines_loop notes.txt
#=> 4
```

#### Arguments

* **$1** (path): The file to count.

#### Output on stdout

* The number of lines.

#### See also

* [file_count_lines](#file_count_lines)

### file_extract_between

Print the lines between two marker lines, not including
the markers. Each marker must match a whole line exactly.

#### Example

```bash
file_extract_between doc.md "<!-- start -->" "<!-- end -->"
#=> keep me
```

#### Arguments

* **$1** (path): The file to read.
* **$2** (string): The opening marker line.
* **$3** (string): The closing marker line.

#### Output on stdout

* The lines between the markers.

### file_read_array

Read a file into an array, one element per line. Pass the
array's name, not "${arr[@]}".

Requires bash 4+.
Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
file_read_array lines notes.txt; echo "${#lines[@]} ${lines[0]}"
#=> 4 line 1
```

#### Arguments

* **$1** (name): Name of the array to fill.
* **$2** (path): The file to read.

#### Variables set

* **$1** (array): The named array, one line per element.

#### See also

* [file_read](#file_read)

