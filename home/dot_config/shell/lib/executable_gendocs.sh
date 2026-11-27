#!/bin/sh
# Regenerate docs/ from the shdoc comments in sh/, bash/ and zsh/.
# Needs shdoc and gawk on PATH (both are installed by mise).
#
# Run it from the chezmoi source so the generated pages land in the repo:
#   cd "$(chezmoi source-path)/dot_config/shell/lib" && ./executable_gendocs.sh
set -eu
cd "$(dirname "$0")"
command -v shdoc >/dev/null || { echo "shdoc not found (mise install)" >&2; exit 1; }
for f in sh/*.sh bash/*.bash zsh/*.zsh; do
    mkdir -p "docs/${f%/*}"
    shdoc < "$f" > "docs/$f.md"
    echo "docs/$f.md"
done
