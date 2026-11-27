# shellcheck disable=all # shellcheck has no zsh support

# @file sys.zsh
# @brief System functions for zsh.
# @description
#   zsh versions of the functions in bash/sys.bash, written with zsh's
#   own features. Each starts with `emulate -L zsh`, so your shell options
#   don't change how it behaves. Based on the pure-bash-bible (MIT).
#   License, naming and notes: see LICENSE-pure and README.md in ~/.config/shell/lib.

# @description Open files in $EDITOR, or vi if $EDITOR is not set.
#
# @example
#   sys_edit notes.txt
#
# @arg $@ path The files to open.
sys_edit() {
    emulate -L zsh
    "${EDITOR:-vi}" "$@"
}

# @description Print the machine's host name, from zsh's $HOST.
#
# @example
#   sys_hostname
#   #=> my-mac.local
#
# @noargs
# @stdout The host name.
sys_hostname() {
    emulate -L zsh
    print -r -- "$HOST"
}

# @description Print the operating system's kernel name in lowercase, the
#   way Go, Rust and Node name it: darwin, linux, freebsd, openbsd,
#   netbsd, dragonfly, solaris, aix or windows (Cygwin, MSYS2 and Git
#   Bash). Any other OS is printed as $OSTYPE gives it, without the version in lowercase. For the
#   Linux distribution, use sys_distro.
#
# @example
#   sys_os
#   #=> darwin
#
# @noargs
# @stdout The OS name.
# @see sys_distro
sys_os() {
    emulate -L zsh
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
        *) os=${(L)OSTYPE%%[0-9]*} ;;
    esac
    print -r -- "$os"
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
    emulate -L zsh
    local arch=$CPUTYPE
    # Under Rosetta, $CPUTYPE is x86_64; this sysctl is 1 there.
    if [[ $arch == x86_64 && $OSTYPE == darwin* &&
        $(sysctl -n sysctl.proc_translated 2>/dev/null) == 1 ]]; then
        arch=arm64
    fi
    case $arch in
        x86_64 | amd64 | AMD64 | x64) arch=x86_64 ;;
        aarch64 | arm64 | ARM64) arch=aarch64 ;;
        i[3-6]86 | i86pc | x86) arch=i686 ;;
    esac
    print -r -- "$arch"
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
    emulate -L zsh
    local file key val
    for file in /etc/os-release /usr/lib/os-release; do
        [[ -r $file ]] || continue
        while IFS='=' read -r key val || [[ -n $key ]]; do
            if [[ $key == ID ]]; then
                val=${${val#[\"\']}%[\"\']}
                print -r -- "$val"
                return 0
            fi
        done < "$file"
    done
    case $OSTYPE in
        darwin*) print -r -- macos ;;
        *) sys_os ;;
    esac
}

# @description Sleep for some seconds without the 'sleep' command, using
#   zsh's zselect module. Fractions work, to 1/100 second.
#
# @example
#   sys_sleep 0.5
#
# @arg $1 number Seconds to sleep.
sys_sleep() {
    emulate -L zsh
    zmodload -F zsh/zselect b:zselect
    local -i centisecs=$(( $1 * 100 ))
    zselect -t $centisecs || :
}

# @description Test whether a program is installed (found in PATH).
#
# @example
#   sys_has_cmd ls && echo installed
#   #=> installed
#
# @arg $1 string The program name.
# @exitcode 0 If it is installed.
# @exitcode 1 If not.
sys_has_cmd() {
    emulate -L zsh
    # Like bash's 'type -p': a builtin, function or alias of that name wins.
    [[ $(whence -w -- "$1") == *': command' ]]
}

# @description Print the current date and time in a strftime format,
#   without the 'date' command.
#
# @example
#   sys_date "%Y-%m-%d %H:%M"
#   #=> 2026-11-22 14:05
#
# @arg $1 string A strftime format.
# @stdout The formatted date.
sys_date() {
    emulate -L zsh
    zmodload -F zsh/datetime b:strftime p:EPOCHSECONDS
    strftime "$1" "$EPOCHSECONDS"
}

# @description Print the current user's name, without 'whoami'.
#
# @example
#   sys_username
#   #=> me
#
# @noargs
# @stdout The user name.
sys_username() {
    emulate -L zsh
    print -r -- "$USERNAME"
}

# @description Print a random UUID (version 4). Reads 16 bytes from
#   /dev/urandom with 'od', so unlike the bash version it is suitable
#   where unpredictability matters.
#
# @example
#   sys_uuid
#   #=> d5b6c731-1310-4c24-9fe3-55d556d44374
#
# @noargs
# @stdout The UUID.
sys_uuid() {
    emulate -L zsh
    local -a b
    b=($(od -An -N16 -tx1 /dev/urandom))
    printf '%s%s%s%s-%s%s-4%s%s-%02x%s-%s%s%s%s%s%s\n' \
        "${(@)b[1,6]}" "${b[7]#?}" "$b[8]" \
        "$(( (0x$b[9] & 0x3f) | 0x80 ))" "$b[10]" "${(@)b[11,16]}"
}

# @description Run a command fully detached in the background. It keeps
#   running if the shell exits, and its output is discarded.
#
# @example
#   sys_background ./long_job.sh
#
# @arg $@ string The command and its arguments.
sys_background() {
    emulate -L zsh
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
    emulate -L zsh
    print -rl -- ${(ok)functions}
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
    emulate -L zsh
    local src=${funcfiletrace[1]%:*}
    [[ -n $src && $src != "$ZSH_ARGZERO" ]]
}
