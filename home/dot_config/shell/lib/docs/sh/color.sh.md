# color.sh

Color functions for POSIX sh.

## Overview

Ported from https://github.com/dylanaraps/pure-bash-bible
(MIT); the pure-sh-bible has no color functions. License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [color_is_hex](#color_is_hex)
* [color_hex_to_rgb](#color_hex_to_rgb)
* [color_rgb_to_hex](#color_rgb_to_hex)

### color_is_hex

Check a hex color like #fff or #A1B2C3 (the # is optional).

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
color_is_hex "#FFFFFF"
#=> #FFFFFF
color_is_hex red
#=> error: red is an invalid color.
```

#### Arguments

* **$1** (string): The color to check.

#### Exit codes

* **0**: If the color is valid.
* **1**: If not.

#### Output on stdout

* The color if valid, else an error message.

### color_hex_to_rgb

Convert a six-digit hex color to decimal R G B values.

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
color_hex_to_rgb "#FF8000"
#=> 255 128 0
```

#### Arguments

* **$1** (string): Hex color, #RRGGBB or RRGGBB.

#### Variables set

* **r** (int): Red value (global).
* **g** (int): Green value (global).
* **b** (int): Blue value (global).

#### Output on stdout

* "R G B" as decimal numbers.

#### See also

* [color_rgb_to_hex](#color_rgb_to_hex)

### color_rgb_to_hex

Convert decimal R G B values to a lowercase hex color.

Source: ported from the bash version; not in the pure-sh-bible.

#### Example

```bash
color_rgb_to_hex 255 128 0
#=> #ff8000
```

#### Arguments

* **$1** (int): Red, 0-255.
* **$2** (int): Green, 0-255.
* **$3** (int): Blue, 0-255.

#### Output on stdout

* The color as #rrggbb.

#### See also

* [color_hex_to_rgb](#color_hex_to_rgb)

