# term.zsh

Terminal functions for zsh.

## Overview

zsh versions of the functions in bash/term.bash, written with zsh's
own features. Each starts with `emulate -L zsh`, so your shell options
don't change how it behaves. Based on the pure-bash-bible (MIT).
License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [term_size](#term_size)
* [term_progress_bar](#term_progress_bar)
* [term_window_size](#term_window_size)
* [term_cursor_pos](#term_cursor_pos)

### term_size

Print the terminal size as "lines columns".

#### Example

```bash
term_size
#=> 40 120
```

_Function has no arguments._

#### Output on stdout

* "LINES COLUMNS".

### term_progress_bar

Draw a progress bar on the current line. Call it
repeatedly with a rising percentage, then print a newline when done.

#### Example

```bash
for p in 0 50 100; do term_progress_bar "$p" 10; sleep 0.2; done; echo
#=> [----------]
```

#### Arguments

* **$1** (int): Percent done, 0-100.
* **$2** (int): Bar width in characters.

#### Output on stdout

* The bar, ending in a carriage return.

### term_window_size

Print the terminal window size in pixels. Prints just "x"
if the terminal does not answer. Works inside tmux.

#### Example

```bash
term_window_size
#=> 1200x800
```

_Function has no arguments._

#### Output on stdout

* "WIDTHxHEIGHT" in pixels.

### term_cursor_pos

Print the cursor position, both values starting at 1.

#### Example

```bash
term_cursor_pos
#=> 1 8
```

_Function has no arguments._

#### Output on stdout

* "COLUMN LINE".

