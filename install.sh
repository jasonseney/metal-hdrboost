#!/usr/bin/env bash
set -e

DEST="/usr/local/bin"            # use /opt/homebrew/bin on Apple Silicon if you prefer
echo "Installing hdrboost to $DEST (sudo may prompt)…"
curl -sL https://github.com/jasonseney/metal-hdrboost/releases/latest/download/hdrboost.zip |
  tar -xz -C "$DEST"
chmod +x "$DEST/hdrboost"

echo "✅  Installed. Run 'hdrboost &' or import the Shortcut to toggle."