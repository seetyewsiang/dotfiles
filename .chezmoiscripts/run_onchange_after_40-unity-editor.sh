#!/bin/sh
# Install the Unity CLI and a pinned Unity Editor with build modules.
# Re-runs whenever this file changes, e.g. when the version is bumped.
set -eu

version=6000.3.27f1
# The Editor builds macOS (Mono) on its own; mac-il2cpp adds IL2CPP.
modules="android ios webgl windows-mono linux-mono mac-il2cpp"

if [ ! -f "$HOME/.unity/env" ]; then
  curl -fsSL https://public-cdn.cloud.unity3d.com/hub/prod/cli/install.sh | UNITY_CLI_CHANNEL=beta bash
fi
# shellcheck source=/dev/null
. "$HOME/.unity/env"

set --
for module in $modules; do
  set -- "$@" --module "$module"
done

if unity editors path "$version" --no-banner >/dev/null 2>&1; then
  unity install-modules --editor-version "$version" "$@" \
    --yes --accept-eula --non-interactive --no-banner
else
  unity install "$version" "$@" \
    --yes --accept-eula --non-interactive --no-banner
fi
