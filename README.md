# metal-hdrboost

😎 Max HDR Brightness for Apple Silicon Metal Capable Displays. 

Works on any XDR‑capable Mac display (14‑inch, 16‑inch, Studio Display, etc.).

### Unsigned build (first run requires OK button)

1. Download **hdrboost** from the latest release  
2. Move `hdrboost` into `/usr/local/bin` or `~/bin`  
3. First launch: right‑click `hdrboost` → *Open* → *Open*.  
   Gatekeeper records your approval; future launches work normally.
4. Optional: `xattr -d com.apple.quarantine /usr/local/bin/hdrboost`


### 🖥  Quick install

```zsh
curl -sL https://github.com/jasonseney/metal-hdrboost/raw/main/install.sh | bash
```

### Usage

1. Start up the app in terminal
2. Press Ctrl ⌥ ⌘ B anywhere to toggle full‑panel HDR brightness.

### TODOS:

- [] Add shortcut file
- [] Remove hotkeys hardcoded and use signals for user defined shortcut hotkeys
