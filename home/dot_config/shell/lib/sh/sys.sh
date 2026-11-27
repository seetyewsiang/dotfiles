# shellcheck shell=sh

# @file sys.sh
# @brief System and environment functions for POSIX sh.
# @description
#   From https://github.com/dylanaraps/pure-sh-bible
#   (MIT). License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

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

# @description Print the machine's host name, from $HOSTNAME or
#   'uname -n'.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_hostname
#   #=> my-mac.local
#
# @noargs
# @stdout The host name.
sys_hostname() {
    printf '%s\n' "${HOSTNAME:-$(uname -n)}"
}

# @description Print the operating system's kernel name in lowercase, the
#   way Go, Rust and Node name it: darwin, linux, freebsd, openbsd,
#   netbsd, dragonfly, solaris, aix or windows (Cygwin, MSYS2 and Git
#   Bash). Any other OS is printed as 'uname -s' gives it in lowercase. For the
#   Linux distribution, use sys_distro.
#
#   Uses 'uname -s', as sh has no $OSTYPE.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_os
#   #=> darwin
#
# @noargs
# @stdout The OS name.
# @see sys_distro
sys_os() {
    os=$(uname -s)
    case $os in
        Darwin) os=darwin ;;
        Linux) os=linux ;;
        FreeBSD) os=freebsd ;;
        OpenBSD) os=openbsd ;;
        NetBSD) os=netbsd ;;
        DragonFly) os=dragonfly ;;
        SunOS) os=solaris ;;
        AIX) os=aix ;;
        CYGWIN* | MSYS* | MINGW*) os=windows ;;
        *) os=$(printf '%s\n' "$os" | tr '[:upper:]' '[:lower:]') ;;
    esac
    printf '%s\n' "$os"
}

# @description Print the CPU architecture, with one name per architecture
#   whatever the OS calls it: x86_64 (also called amd64 or x64), aarch64
#   (arm64) and i686 (i386 to i686). Other names, such as armv7l or
#   riscv64, are printed as the OS gives them. On a Mac it reports the
#   real CPU, even when the shell runs under Rosetta.
#
#   Source: not in the pure-sh-bible.
#
# @example
#   sys_arch
#   #=> aarch64
#
# @noargs
# @stdout The architecture name.
sys_arch() {
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
#   Source: not in the pure-sh-bible.
#
# @example
#   sys_distro
#   #=> macos
#
# @noargs
# @stdout The distribution id.
# @see sys_os
sys_distro() {
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
    case $(uname -s) in
        Darwin) printf '%s\n' macos ;;
        *) sys_os ;;
    esac
}

# @description Sleep for some seconds. sh can't sleep without the
#   'sleep' command, so this just runs it. Fractions work on macOS and
#   Linux, but POSIX only requires whole seconds.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_sleep 0.5
#
# @arg $1 number Seconds to sleep.
sys_sleep() {
    sleep "$1"
}

# @description Test whether a program is installed (found in PATH).
#   Builtins, functions and aliases don't count, as with bash's 'type -p'.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_has_cmd ls && echo installed
#   #=> installed
#
# @arg $1 string The program name.
# @exitcode 0 If it is installed.
# @exitcode 1 If not.
sys_has_cmd() {
    case $(command -v "$1" 2>/dev/null) in
        /*) return 0 ;;
    esac
    return 1
}

# @description Print the current date and time in a strftime format.
#   Runs 'date', as sh has no built-in way to read the clock.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_date "%Y-%m-%d %H:%M"
#   #=> 2026-11-22 14:05
#
# @arg $1 string A strftime format.
# @stdout The formatted date.
sys_date() {
    date +"$1"
}

# @description Print the current user's name. Runs 'id -un'.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_username
#   #=> me
#
# @noargs
# @stdout The user name.
sys_username() {
    id -un
}

# @description Print a random UUID (version 4). Reads 16 bytes from
#   /dev/urandom with 'od', so unlike the bash version it is suitable
#   where unpredictability matters.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_uuid
#   #=> d5b6c731-1310-4c24-9fe3-55d556d44374
#
# @noargs
# @stdout The UUID.
sys_uuid() {
    set -- $(od -An -N16 -tx1 /dev/urandom)
    printf '%s%s%s%s-%s%s-4%s%s-%02x%s-%s%s%s%s%s%s\n' \
        "$1" "$2" "$3" "$4" "$5" "$6" "${7#?}" "$8" \
        "$(( (0x$9 & 0x3f) | 0x80 ))" "${10}" \
        "${11}" "${12}" "${13}" "${14}" "${15}" "${16}"
}

# @description Run a command fully detached in the background. It keeps
#   running if the shell exits, and its output is discarded.
#
#   Source: ported from the bash version; not in the pure-sh-bible.
#
# @example
#   sys_background ./long_job.sh
#
# @arg $@ string The command and its arguments.
sys_background() {
    (nohup "$@" >/dev/null 2>&1 &)
}
