# shellcheck shell=bash

# @file sys.bash
# @brief System and environment functions for bash.
# @description
#   From https://github.com/dylanaraps/pure-bash-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.
#   Functions marked "Requires bash 4+" (or newer) fail on the bash 3.2 that macOS ships.

# @description Open files in $EDITOR, or vi if $EDITOR is not set.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   sys_edit notes.txt
#
# @arg $@ path The files to open.
sys_edit() {
    "${EDITOR:-vi}" "$@"
}

# @description Print the machine's host name, from $HOSTNAME or the
#   hostname command.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   sys_hostname
#   #=> my-mac.local
#
# @noargs
# @stdout The host name.
sys_hostname() {
    printf '%s\n' "${HOSTNAME:-$(hostname)}"
}

# @description Print the operating system's kernel name in lowercase, the
#   way Go, Rust and Node name it: darwin, linux, freebsd, openbsd,
#   netbsd, dragonfly, solaris, aix or windows (Cygwin, MSYS2 and Git
#   Bash). Any other OS is printed as $OSTYPE gives it, without the version in lowercase. For the
#   Linux distribution, use sys_distro.
#
#   Change: upstream printed MacOS, Linux, BSD or Windows and exited on any
#   other OS.
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   sys_os
#   #=> darwin
#
# @noargs
# @stdout The OS name.
# @see sys_distro
sys_os() {
    local os
    case $OSTYPE in
        darwin*) os=darwin ;;
        linux*) os=linux ;;
        freebsd*) os=freebsd ;;
        openbsd*) os=openbsd ;;
        netbsd*) os=netbsd ;;
        dragonfly*) os=dragonfly ;;
        solaris*) os=solaris ;;
        aix*) os=aix ;;
        cygwin* | msys* | win32*) os=windows ;;
        *) os=${OSTYPE%%[0-9]*} ;;
    esac
    printf '%s\n' "$os"
}

# @description Print the CPU architecture, with one name per architecture
#   whatever the OS calls it: x86_64 (also called amd64 or x64), aarch64
#   (arm64) and i686 (i386 to i686). Other names, such as armv7l or
#   riscv64, are printed as the OS gives them. On a Mac it reports the
#   real CPU, even when the shell runs under Rosetta.
#
# @example
#   sys_arch
#   #=> aarch64
#
# @noargs
# @stdout The architecture name.
sys_arch() {
    local arch
    arch=$(uname -m)
    # Under Rosetta, uname says x86_64; this sysctl is 1 there.
    if [ "$arch" = x86_64 ] && [ "$(uname -s)" = Darwin ] &&
        [ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" = 1 ]; then
        arch=arm64
    fi
    case $arch in
        x86_64 | amd64 | AMD64 | x64) arch=x86_64 ;;
        aarch64 | arm64 | ARM64) arch=aarch64 ;;
        i[3-6]86 | i86pc | x86) arch=i686 ;;
    esac
    printf '%s\n' "$arch"
}

# @description Print the distribution's id: ubuntu, debian, fedora,
#   alpine, arch and so on, from the ID line of /etc/os-release (or
#   /usr/lib/os-release). On a Mac it prints macos. Where there is no
#   os-release file, it prints what sys_os prints.
#
# @example
#   sys_distro
#   #=> macos
#
# @noargs
# @stdout The distribution id.
# @see sys_os
sys_distro() {
    local file key val
    for file in /etc/os-release /usr/lib/os-release; do
        [ -r "$file" ] || continue
        while IFS='=' read -r key val || [ -n "$key" ]; do
            if [ "$key" = ID ]; then
                val=${val#[\"\']} val=${val%[\"\']}
                printf '%s\n' "$val"
                return 0
            fi
        done < "$file"
    done
    case $OSTYPE in
        darwin*) printf '%s\n' macos ;;
        *) sys_os ;;
    esac
}

# @description Sleep for some seconds without the 'sleep' command.
#   Fractions work.
#   Note: on macOS bash 3.2 this failed in testing ("/dev/fd/62:
#   Permission denied") and returned at once instead of sleeping.
#
# @example
#   sys_sleep 0.5
#
# @arg $1 number Seconds to sleep.
sys_sleep() {
    read -rt "$1" <> <(:) || :
}

# @description Test whether a program is installed (found in PATH).
#
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   sys_has_cmd ls && echo installed
#   #=> installed
#
# @arg $1 string The program name.
# @exitcode 0 If it is installed.
# @exitcode 1 If not.
sys_has_cmd() {
    type -p "$1" &>/dev/null
}

# @description Print the current date and time in a strftime format,
#   without the 'date' command.
#
#   Requires bash 4.2+.
#
# @example
#   sys_date "%Y-%m-%d %H:%M"
#   #=> 2026-11-22 14:05
#
# @arg $1 string A strftime format.
# @stdout The formatted date.
sys_date() {
    printf "%($1)T\\n" "-1"
}

# @description Print the current user's name, without 'whoami'.
#
#   Requires bash 4.4+.
#   Source: wrapped from a bible snippet, not upstream code.
#
# @example
#   sys_username
#   #=> me
#
# @noargs
# @stdout The user name.
sys_username() {
    : \\u
    printf '%s\n' "${_@P}"
}

# @description Print a random UUID (version 4). Uses $RANDOM, so it is not
#   cryptographically secure.
#
# @example
#   sys_uuid
#   #=> d5b6c731-1310-4c24-9fe3-55d556d44374
#
# @noargs
# @stdout The UUID.
sys_uuid() {
    C="89ab"
    for ((N=0;N<16;++N)); do
        B="$((RANDOM%256))"
        case "$N" in
            6)  printf '4%x' "$((B%16))" ;;
            8)  printf '%c%x' "${C:$RANDOM%${#C}:1}" "$((B%16))" ;;
            3|5|7|9)
                printf '%02x-' "$B"
            ;;
            *)
                printf '%02x' "$B"
            ;;
        esac
    done
    printf '\n'
}

# @description Run a command fully detached in the background. It keeps
#   running if the shell exits, and its output is discarded.
#
# @example
#   sys_background ./long_job.sh
#
# @arg $@ string The command and its arguments.
sys_background() {
    (nohup "$@" &>/dev/null &)
}

# @description Print the names of all shell functions defined right now.
#
# @example
#   sys_functions
#   #=> str_trim
#   #=> sys_uuid
#
# @noargs
# @stdout One function name per line.
sys_functions() {
    IFS=$'\n' read -d "" -ra functions < <(declare -F)
    printf '%s\n' "${functions[@]//declare -f }"
}

# @description Test whether the file that calls this was sourced (read with
#   `source` or `.`) rather than run. Use it to run a script's main code
#   only when the script is run, so other scripts can source it for its
#   functions.
#
# @example
#   main() {
#       echo "running"
#   }
#   sys_is_sourced || main "$@"
#
# @noargs
# @exitcode 0 If the calling file was sourced.
# @exitcode 1 If it was run, or this was called from the prompt.
sys_is_sourced() {
    [[ -n ${BASH_SOURCE[1]:-} && ${BASH_SOURCE[1]} != "$0" ]]
}
