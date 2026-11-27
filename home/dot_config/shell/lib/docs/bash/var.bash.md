# var.bash

Variable functions for bash.

## Overview

From https://github.com/dylanaraps/pure-bash-bible
(MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

## Index

* [var_set](#var_set)
* [var_get](#var_get)
* [var_to_upper](#var_to_upper)

### var_set

Assign a value to a variable whose name is in another
variable. Uses printf -v, so the variable is not local to this
function.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
suffix=world; var_set "hello_$suffix" value; echo "$hello_world"
#=> value
```

#### Arguments

* **$1** (name): Name of the variable to set.
* **$2** (string): The value.

#### Variables set

* **$1** (string): The named variable.

#### See also

* [var_get](#var_get)

### var_get

Print the value of a variable whose name is in another
variable.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
hello_world=value; var_get hello_world
#=> value
```

#### Arguments

* **$1** (name): Name of the variable to read.

#### Output on stdout

* The variable's value.

#### See also

* [var_set](#var_set)

### var_to_upper

Uppercase a variable in place, without a subshell. Pass the
variable's name, not its value.

Requires bash 4.3+.

#### Example

```bash
foo=bar; var_to_upper foo; echo "$foo"
#=> BAR
```

#### Arguments

* **$1** (name): Name of the variable to uppercase.

#### Variables set

* **$1** (string): The named variable, uppercased.

