#!/usr/bin/bash
# Verify a rendered ~/.config/hypr tree with Hyprland's own parser.
# Usage: verify-lua.sh <hypr-dir>
# Runs Hyprland directly when available, otherwise inside the atomic-hyprland image.
set -uo pipefail
dir="${1:?hypr dir}"
image="${HYPR_VERIFY_IMAGE:-ghcr.io/danmwallace/atomic-hyprland:44}"

[[ -f "$dir/hyprland.lua" ]] || { echo "verify-lua: no hyprland.lua in $dir" >&2; exit 1; }

run_verify() {
    export HOME="$(mktemp -d)" XDG_RUNTIME_DIR="$(mktemp -d)"
    mkdir -p "$HOME/.config" && cp -r "$1" "$HOME/.config/hypr"
    Hyprland --verify-config --i-am-really-stupid 2>&1 | sed 's/\x1b\[[0-9;]*m//g'
}

if command -v Hyprland >/dev/null 2>&1; then
    out="$(run_verify "$dir")"
else
    self="$(readlink -f "$0")"
    out="$(podman run --rm -v "$(readlink -f "$dir"):/src:ro,Z" -v "$self:/verify.sh:ro,Z" "$image" bash /verify.sh /src)"
fi
echo "$out" | grep -v '^DEBUG' | tail -15
if echo "$out" | grep -q 'config ok' && ! echo "$out" | grep -Eq 'attempt to|stack traceback|Config error'; then
    echo "verify-lua: ok"; exit 0
fi
echo "verify-lua: FAILED" >&2; exit 1
