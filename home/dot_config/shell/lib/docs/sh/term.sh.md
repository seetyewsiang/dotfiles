# term.sh

Terminal functions for POSIX sh.

## Overview

Ported from https://github.com/dylanaraps/pure-bash-bible
(MIT); the pure-sh-bible has no terminal functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [term_size](#term_size)
* [term_progress_bar](#term_progress_bar)

### term_size

Print the terminal size as "lines columns". Runs
'stty size', which macOS, Linux and the BSDs have but POSIX doesn't
require.

Source: ported from the bash version; not in the pure-sh-bible.

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

Source: ported from the bash version; not in the pure-sh-bible.

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

