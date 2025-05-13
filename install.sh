#!/usr/bin/env bash
set -euo pipefail

# Where to put it
BIN_DIR="${BIN_DIR:-/usr/local/bin}"
[[ $(uname -m) == "arm64" && ! -d /usr/local ]] && BIN_DIR="/opt/homebrew/bin"

sudo mkdir -p "$BIN_DIR"

echo "→ Downloading hdrboost to $BIN_DIR"

curl -sL --fail -o "$BIN_DIR/hdrboost" \
     https://github.com/jasonseney/metal-hdrboost/releases/latest/download/hdrboost
sudo chmod +x "$BIN_DIR/hdrboost"

echo "✅ Installed.  Run:  hdrboost &"
