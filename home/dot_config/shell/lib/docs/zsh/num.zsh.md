# num.zsh

Number functions for zsh.

## Overview

zsh versions of the functions in bash/num.bash, written with zsh's
own features. Each starts with `emulate -L zsh`, so your shell options
don't change how it behaves. Based on the pure-bash-bible (MIT).
License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [num_range](#num_range)
* [num_max](#num_max)
* [num_is_float](#num_is_float)
* [num_is_int](#num_is_int)

### num_range

Print every integer from start to end, inclusive.

#### Example

```bash
num_range 3 5
#=> 3
#=> 4
#=> 5
```

#### Arguments

* **$1** (int): First number.
* **$2** (int): Last number.

#### Output on stdout

* Each integer, one per line.

### num_max

Print the larger of two integers.

#### Example

```bash
num_max 3 7
#=> 7
```

#### Arguments

* **$1** (int): First number.
* **$2** (int): Second number.

#### Output on stdout

* The larger number.

### num_is_float

Test whether a value is a decimal number with a dot, like
1.5. Whole numbers do not count.

#### Example

```bash
num_is_float 1.5 && echo yes
#=> yes
num_is_float 2 || echo no
#=> no
```

#### Arguments

* **$1** (string): The value to test.

#### Exit codes

* **0**: If it is a decimal number.
* **1**: If not.

### num_is_int

Test whether a value is a whole number, optionally signed.

#### Example

```bash
num_is_int -42 && echo yes
#=> yes
num_is_int 1.1 || echo no
#=> no
```

#### Arguments

* **$1** (string): The value to test.

#### Exit codes

* **0**: If it is a whole number.
* **1**: If not.

