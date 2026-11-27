# arr.sh

Array functions for POSIX sh. sh has no arrays, so each function takes the elements as arguments.

## Overview

Ported from https://github.com/dylanaraps/pure-bash-bible
(MIT); the pure-sh-bible has no array functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [arr_contains](#arr_contains)
* [arr_reverse](#arr_reverse)
* [arr_dedupe](#arr_dedupe)
* [arr_random](#arr_random)

### arr_contains

Test whether any element contains a substring.
The elements are joined with spaces first, so a match can also span
two elements ("d b" matches red blue).

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
arr_contains blue red blue green && echo yes
#=> yes
```

#### Arguments

* **$1** (string): The substring to look for.
* **...** (string): The elements, as "$@".

#### Exit codes

* **0**: If found.
* **1**: If not.

### arr_reverse

Print the elements in reverse order, one per line.

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
arr_reverse red blue green
#=> green
#=> blue
#=> red
```

#### Arguments

* **...** (string): The elements, as "$@".

#### Output on stdout

* The elements in reverse order, one per line.

### arr_dedupe

Print the elements with duplicates removed, one per line,
in the order they first appear. Empty elements are skipped.

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
arr_dedupe red red green blue blue
#=> red
#=> green
#=> blue
```

#### Arguments

* **...** (string): The elements, as "$@".

#### Output on stdout

* Each distinct element, one per line.

### arr_random

Print one element chosen at random. Reads /dev/urandom
with 'od', as sh has no $RANDOM.

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
arr_random red green blue
#=> green
```

#### Arguments

* **...** (string): The elements, as "$@".

#### Output on stdout

* One random element.

