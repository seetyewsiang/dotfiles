# arr.zsh

Array functions for zsh.

## Overview

zsh versions of the functions in bash/arr.bash, written with zsh's
own features. Each starts with `emulate -L zsh`, so your shell options
don't change how it behaves. Based on the pure-bash-bible (MIT).
License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [arr_contains](#arr_contains)
* [arr_reverse](#arr_reverse)
* [arr_dedupe](#arr_dedupe)
* [arr_random](#arr_random)
* [arr_cycle](#arr_cycle)

### arr_contains

Test whether any array element contains a substring.
The elements are joined with spaces first, so a match can also span
two elements ("d b" matches red blue).

#### Example

```bash
arr_contains blue red blue green && echo yes
#=> yes
```

#### Arguments

* **$1** (string): The substring to look for.
* **...** (string): The array elements, as "${arr[@]}".

#### Exit codes

* **0**: If found.
* **1**: If not.

### arr_reverse

Print the elements in reverse order, one per line.

#### Example

```bash
arr_reverse red blue green
#=> green
#=> blue
#=> red
```

#### Arguments

* **...** (string): The array elements, as "${arr[@]}".

#### Output on stdout

* The elements in reverse order, one per line.

### arr_dedupe

Print the elements with duplicates removed, one per line.
Keeps the order they first appear in; empty elements are skipped.

#### Example

```bash
arr_dedupe red red green blue blue
#=> red
#=> green
#=> blue
```

#### Arguments

* **...** (string): The array elements, as "${arr[@]}".

#### Output on stdout

* Each distinct element, one per line.

### arr_random

Print one element chosen at random.

#### Example

```bash
arr_random red green blue
#=> green
```

#### Arguments

* **...** (string): The array elements, as "${arr[@]}".

#### Output on stdout

* One random element.

### arr_cycle

Print the next element of the global array 'arr' on each
call, followed by a space, wrapping around at the end. For a toggle,
set arr=(true false).

#### Example

```bash
arr=(a b c); arr_cycle; arr_cycle; arr_cycle; arr_cycle; echo
#=> a b c a
```

_Function has no arguments._

#### Variables set

* **i** (int): Position of the next element (global).

#### Output on stdout

* The next element of arr, followed by a space.

