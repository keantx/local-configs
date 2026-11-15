#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ZED_PATH=""
for candidate in "/Applications/Zed.app" "$HOME/Applications/Zed.app"; do
    if [[ -d "$candidate" ]]; then
        ZED_PATH="$candidate"
        break
    fi
done

if [[ -z "$ZED_PATH" ]] && command -v zed >/dev/null 2>&1; then
    ZED_PATH="$(command -v zed)"
fi

if [[ -z "$ZED_PATH" ]]; then
    echo "Zed is not installed. Nothing to do." >&2
    exit 1
fi
echo "Zed found: $ZED_PATH"

ZED_DIR="$HOME/.config/zed"
mkdir -p "$ZED_DIR"
echo "Config dir: $ZED_DIR"

STAMP="$(date +%Y%m%d-%H%M%S)"

install_file() {
    local src_name="$1" dest_name="$2"
    local src="$SCRIPT_DIR/$src_name"
    local dest="$ZED_DIR/$dest_name"

    if [[ ! -f "$src" ]]; then
        echo "Missing $src, skipping." >&2
        return
    fi
    if [[ -f "$dest" ]]; then
        cp "$dest" "$dest.bak-$STAMP"
        echo "Backed up $dest_name -> $dest_name.bak-$STAMP"
    fi
    cp "$src" "$dest"
    echo "Installed $src_name -> $dest"
}

install_file "macos-settings.json" "settings.json"
install_file "macos-keymap.json"   "keymap.json"
