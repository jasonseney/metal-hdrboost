# metal-hdrboost

😎 Full‑send your Mac’s HDR.

`hdrboost` is a tiny Metal overlay that unlocks true XDR nits on any Apple‑silicon display – install with one curl, toggle with a hot‑key. A single‑file Swift binary - no GUI that flips on your Mac’s hidden “sun mode” and blasts HDR to full 1,000 nit glory.

### 🖥  Quick install

```zsh
curl -sL https://github.com/jasonseney/metal-hdrboost/raw/main/install.sh | bash
```

### Using Manual build (first run requires OK button)

1. Download **hdrboost** from the latest release  
2. Move `hdrboost` into `/usr/local/bin` or `~/bin`  
3. First launch: right‑click `hdrboost` → *Open* → *Open*.  
   Gatekeeper records your approval; future launches work normally.
4. Optional: `xattr -d com.apple.quarantine /usr/local/bin/hdrboost`

### Usage

1. Start up the app in terminal, or createa  shortcut.
2. Press Ctrl ⌥ ⌘ B anywhere to toggle full‑panel HDR brightness.

### TODOS:

- [ ] Add shortcut file
- [ ] Remove hotkeys hardcoded and use signals for user defined shortcut hotkeys

### Known Issues:

- Brightness will dim (to normal) and back to bright when switching virtual desktops.
