# str.zsh

String functions for zsh.

## Overview

zsh versions of the functions in bash/str.bash, written with zsh's
own features. Each starts with `emulate -L zsh`, so your shell options
don't change how it behaves. Based on the pure-bash-bible (MIT).
License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

## Index

* [str_lstrip](#str_lstrip)
* [str_rstrip](#str_rstrip)
* [str_trim](#str_trim)
* [str_trim_all](#str_trim_all)
* [str_contains](#str_contains)
* [str_starts_with](#str_starts_with)
* [str_ends_with](#str_ends_with)
* [str_split](#str_split)
* [str_strip_quotes](#str_strip_quotes)
* [str_lower](#str_lower)
* [str_upper](#str_upper)
* [str_swap_case](#str_swap_case)
* [str_strip_all](#str_strip_all)
* [str_strip](#str_strip)
* [str_urlencode](#str_urlencode)
* [str_urldecode](#str_urldecode)
* [str_regex](#str_regex)

### str_lstrip

Remove a pattern from the start of a string.
The pattern is a shell glob; the longest match is removed.

#### Example

```bash
str_lstrip "The Quick Brown Fox" "The "
#=> Quick Brown Fox
str_lstrip "v1.2.3" "v"
#=> 1.2.3
```

#### Arguments

* **$1** (string): The input string.
* **$2** (pattern): Glob to remove from the start.

#### Output on stdout

* The string without the matched prefix.

### str_rstrip

Remove a pattern from the end of a string.
The pattern is a shell glob; the longest match is removed.

#### Example

```bash
str_rstrip "The Quick Brown Fox" " Fox"
#=> The Quick Brown
str_rstrip "report.tar.gz" ".*"
#=> report
```

#### Arguments

* **$1** (string): The input string.
* **$2** (pattern): Glob to remove from the end.

#### Output on stdout

* The string without the matched suffix.

### str_trim

Remove leading and trailing whitespace. Inner spacing is kept.

#### Example

```bash
str_trim "    Hello,  World    "
#=> Hello,  World
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The trimmed string.

#### See also

* [str_trim_all](#str_trim_all)

### str_trim_all

Remove leading and trailing whitespace, and squeeze inner
runs of whitespace to one space.

#### Example

```bash
str_trim_all "    Hello,    World    "
#=> Hello, World
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The trimmed, squeezed string.

#### See also

* [str_trim](#str_trim)

### str_contains

Test whether a string contains a substring.

#### Example

```bash
str_contains "hello world" "lo w" && echo yes
#=> yes
```

#### Arguments

* **$1** (string): The string to search.
* **$2** (string): The substring to look for.

#### Exit codes

* **0**: If the substring is found.
* **1**: If not.

### str_starts_with

Test whether a string starts with a prefix.

#### Example

```bash
str_starts_with "feature/login" "feature/" && echo yes
#=> yes
```

#### Arguments

* **$1** (string): The string to check.
* **$2** (string): The prefix.

#### Exit codes

* **0**: If the string starts with the prefix.
* **1**: If not.

### str_ends_with

Test whether a string ends with a suffix.

#### Example

```bash
str_ends_with "photo.jpg" ".jpg" && echo yes
#=> yes
```

#### Arguments

* **$1** (string): The string to check.
* **$2** (string): The suffix.

#### Exit codes

* **0**: If the string ends with the suffix.
* **1**: If not.

### str_split

Split a string on a delimiter and print each field on its
own line. The delimiter is a whole string, so "---" splits on three
dashes.

#### Example

```bash
str_split "apples,oranges,pears" ","
#=> apples
#=> oranges
#=> pears
str_split "hello---world" "---"
#=> hello
#=> world
```

#### Arguments

* **$1** (string): The string to split.
* **$2** (string): The delimiter.

#### Output on stdout

* Each field, one per line.

### str_strip_quotes

Remove every single and double quote from a string.

#### Example

```bash
str_strip_quotes "'Hello', \"World\""
#=> Hello, World
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The string without quotes.

### str_lower

Convert a string to lowercase.

#### Example

```bash
str_lower "HeLLo"
#=> hello
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The lowercase string.

### str_upper

Convert a string to uppercase.

#### Example

```bash
str_upper "HeLLo"
#=> HELLO
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The uppercase string.

### str_swap_case

Swap the case of every letter.

#### Example

```bash
str_swap_case "HeLlO"
#=> hElLo
```

#### Arguments

* **$1** (string): The input string.

#### Output on stdout

* The string with each letter's case swapped.

### str_strip_all

Remove every match of a pattern anywhere in a string.

#### Example

```bash
str_strip_all "The Quick Brown Fox" "[aeiou]"
#=> Th Qck Brwn Fx
str_strip_all "The Quick Brown Fox" "[[:space:]]"
#=> TheQuickBrownFox
```

#### Arguments

* **$1** (string): The input string.
* **$2** (pattern): Glob to remove everywhere.

#### Output on stdout

* The string with every match removed.

#### See also

* [str_strip](#str_strip)

### str_strip

Remove the first match of a pattern anywhere in a string.

#### Example

```bash
str_strip "The Quick Brown Fox" "[aeiou]"
#=> Th Quick Brown Fox
```

#### Arguments

* **$1** (string): The input string.
* **$2** (pattern): Glob to remove once.

#### Output on stdout

* The string with the first match removed.

#### See also

* [str_strip_all](#str_strip_all)

### str_urlencode

Percent-encode a string for use in a URL. Letters, digits
and . ~ _ - are kept; everything else becomes %XX.

#### Example

```bash
str_urlencode "a b&c/d"
#=> a%20b%26c%2Fd
```

#### Arguments

* **$1** (string): The string to encode.

#### Output on stdout

* The percent-encoded string.

#### See also

* [str_urldecode](#str_urldecode)

### str_urldecode

Decode a percent-encoded string. A + becomes a space.

#### Example

```bash
str_urldecode "a%20b%26c%2Fd+e"
#=> a b&c/d e
```

#### Arguments

* **$1** (string): The string to decode.

#### Output on stdout

* The decoded string.

#### See also

* [str_urlencode](#str_urlencode)

### str_regex

Match a string against an extended regex and print the
first capture group.

#### Example

```bash
str_regex "version 1.2.3" '([0-9]+\.[0-9]+)'
#=> 1.2
str_regex "    hello" '^[[:space:]]*(.*)'
#=> hello
```

#### Arguments

* **$1** (string): The string to match.
* **$2** (regex): Extended regex with at least one capture group.

#### Exit codes

* **0**: If the regex matches.
* **1**: If not.

#### Output on stdout

* The first capture group, if the regex matches.

