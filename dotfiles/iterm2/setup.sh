#!/usr/bin/env bash
# Apply my iTerm2 settings on top of whatever iTerm2 already has:
#   - Cmd+D / Cmd+Shift+D  -> tmux split (sends Alt+v / Alt+s)
#   - Cmd+h/j/k/l          -> Alt+h/j/k/l (tmux + nvim pane navigation via smart-splits)
#   - Default profile starts `tmux new-session -A -s main`
#   - Left/Right Option key send Esc+ (needed for every Alt binding)
# A backup of the current prefs is written next to this script first.
# Restart iTerm2 afterwards.
set -euo pipefail

TMUX_BIN="$(command -v tmux || echo /opt/homebrew/bin/tmux)"
WORK="$(mktemp -d)"
BACKUP="$(cd "$(dirname "$0")" && pwd)/iterm2-backup-$(date +%Y%m%d-%H%M%S).plist"

defaults export com.googlecode.iterm2 "$WORK/prefs.plist"
cp "$WORK/prefs.plist" "$BACKUP"

python3 -I - "$WORK/prefs.plist" "$TMUX_BIN" <<'PY'
import plistlib, sys
path, tmux = sys.argv[1], sys.argv[2]
d = plistlib.load(open(path, "rb"))

# key code - modifier flags - keycode - version ; Cmd = 0x100000, Cmd+Shift = 0x120000
send_alt = {
    "0x64-0x100000-0x2-0x1":  "v",   # Cmd+D
    "0x44-0x120000-0x2-0x1":  "s",   # Cmd+Shift+D
    "0x68-0x100000-0x4-0x1":  "h",   # Cmd+h
    "0x6a-0x100000-0x26-0x1": "j",   # Cmd+j
    "0x6b-0x100000-0x28-0x1": "k",   # Cmd+k
    "0x6c-0x100000-0x25-0x1": "l",   # Cmd+l
}
gk = d.setdefault("GlobalKeyMap", {})
for key, text in send_alt.items():
    gk[key] = {"Action": 10, "Text": text, "Version": 2, "Apply Mode": 0, "Escaping": 2}  # 10 = Send Escape Sequence

guid = d.get("Default Bookmark Guid")
for prof in d.get("New Bookmarks", []):
    if guid is None or prof.get("Guid") == guid:
        prof["Custom Command"] = "Yes"
        prof["Command"] = f"{tmux} new-session -A -s main"
        prof["Option Key Sends"] = 2
        prof["Right Option Key Sends"] = 2
        print("updated profile:", prof.get("Name"))
        break
plistlib.dump(d, open(path, "wb"))
PY

defaults import com.googlecode.iterm2 "$WORK/prefs.plist"
rm -rf "$WORK"
echo "Done. Backup: $BACKUP — restart iTerm2."
