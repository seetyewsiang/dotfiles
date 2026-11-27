# sys.bash

System and environment functions for bash.

## Overview

From https://github.com/dylanaraps/pure-bash-bible
(MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

## Index

* [sys_edit](#sys_edit)
* [sys_hostname](#sys_hostname)
* [sys_os](#sys_os)
* [sys_arch](#sys_arch)
* [sys_distro](#sys_distro)
* [sys_sleep](#sys_sleep)
* [sys_has_cmd](#sys_has_cmd)
* [sys_date](#sys_date)
* [sys_username](#sys_username)
* [sys_uuid](#sys_uuid)
* [sys_background](#sys_background)
* [sys_functions](#sys_functions)
* [sys_is_sourced](#sys_is_sourced)

### sys_edit

Open files in $EDITOR, or vi if $EDITOR is not set.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
sys_edit notes.txt
```

#### Arguments

* **...** (path): The files to open.

### sys_hostname

Print the machine's host name, from $HOSTNAME or the
hostname command.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
sys_hostname
#=> my-mac.local
```

_Function has no arguments._

#### Output on stdout

* The host name.

### sys_os

Print the operating system's kernel name in lowercase, the
way Go, Rust and Node name it: darwin, linux, freebsd, openbsd,
netbsd, dragonfly, solaris, aix or windows (Cygwin, MSYS2 and Git
Bash). Any other OS is printed as $OSTYPE gives it, without the version in lowercase. For the
Linux distribution, use sys_distro.

Change: upstream printed MacOS, Linux, BSD or Windows and exited on any
other OS.

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
sys_os
#=> darwin
```

_Function has no arguments._

#### Output on stdout

* The OS name.

#### See also

* [sys_distro](#sys_distro)

### sys_arch

Print the CPU architecture, with one name per architecture
whatever the OS calls it: x86_64 (also called amd64 or x64), aarch64
(arm64) and i686 (i386 to i686). Other names, such as armv7l or
riscv64, are printed as the OS gives them. On a Mac it reports the
real CPU, even when the shell runs under Rosetta.

#### Example

```bash
sys_arch
#=> aarch64
```

_Function has no arguments._

#### Output on stdout

* The architecture name.

### sys_distro

Print the distribution's id: ubuntu, debian, fedora,
alpine, arch and so on, from the ID line of /etc/os-release (or
/usr/lib/os-release). On a Mac it prints macos. Where there is no
os-release file, it prints what sys_os prints.

#### Example

```bash
sys_distro
#=> macos
```

_Function has no arguments._

#### Output on stdout

* The distribution id.

#### See also

* [sys_os](#sys_os)

### sys_sleep

Sleep for some seconds without the 'sleep' command.
Fractions work.
Note: on macOS bash 3.2 this failed in testing ("/dev/fd/62:
Permission denied") and returned at once instead of sleeping.

#### Example

```bash
sys_sleep 0.5
```

#### Arguments

* **$1** (number): Seconds to sleep.

### sys_has_cmd

Test whether a program is installed (found in PATH).

Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
sys_has_cmd ls && echo installed
#=> installed
```

#### Arguments

* **$1** (string): The program name.

#### Exit codes

* **0**: If it is installed.
* **1**: If not.

### sys_date

Print the current date and time in a strftime format,
without the 'date' command.

Requires bash 4.2+.

#### Example

```bash
sys_date "%Y-%m-%d %H:%M"
#=> 2026-11-22 14:05
```

#### Arguments

* **$1** (string): A strftime format.

#### Output on stdout

* The formatted date.

### sys_username

Print the current user's name, without 'whoami'.

Requires bash 4.4+.
Source: wrapped from a bible snippet, not upstream code.

#### Example

```bash
sys_username
#=> me
```

_Function has no arguments._

#### Output on stdout

* The user name.

### sys_uuid

Print a random UUID (version 4). Uses $RANDOM, so it is not
cryptographically secure.

#### Example

```bash
sys_uuid
#=> d5b6c731-1310-4c24-9fe3-55d556d44374
```

_Function has no arguments._

#### Output on stdout

* The UUID.

### sys_background

Run a command fully detached in the background. It keeps
running if the shell exits, and its output is discarded.

#### Example

```bash
sys_background ./long_job.sh
```

#### Arguments

* **...** (string): The command and its arguments.

### sys_functions

Print the names of all shell functions defined right now.

#### Example

```bash
sys_functions
#=> str_trim
#=> sys_uuid
```

_Function has no arguments._

#### Output on stdout

* One function name per line.

### sys_is_sourced

Test whether the file that calls this was sourced (read with
`source` or `.`) rather than run. Use it to run a script's main code
only when the script is run, so other scripts can source it for its
functions.

#### Example

```bash
main() {
    echo "running"
}
sys_is_sourced || main "$@"
```

_Function has no arguments._

#### Exit codes

* **0**: If the calling file was sourced.
* **1**: If it was run, or this was called from the prompt.

