# var.zsh

Variable functions for zsh.

## Overview

zsh versions of the functions in bash/var.bash, written with zsh's
own features. Each starts with `emulate -L zsh`, so your shell options
don't change how it behaves. Based on the pure-bash-bible (MIT).
License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [var_set](#var_set)
* [var_get](#var_get)
* [var_to_upper](#var_to_upper)

### var_set

Assign a value to a variable whose name is in another
variable. Uses ${(P)name::=value}, so the variable is not local to
this function.

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

#### Example

```bash
foo=bar; var_to_upper foo; echo "$foo"
#=> BAR
```

#### Arguments

* **$1** (name): Name of the variable to uppercase.

#### Variables set

* **$1** (string): The named variable, uppercased.

