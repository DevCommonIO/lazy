#!/usr/bin/env bash
# Refresh this public copy from the private ~/dotfiles repo.
#   ./dotfiles/sync.sh        (run from anywhere)
# Never copies ~/.zshrc.local (work-specific helpers) or the raw iTerm2 plist.
# Aborts if anything that looks private ends up in the copy.
set -euo pipefail

SRC="${DOTFILES_SRC:-$HOME/dotfiles}"
DST="$(cd "$(dirname "$0")" && pwd)"

copy() { mkdir -p "$DST/$(dirname "$2")"; sed "s|$HOME|\$HOME|g" "$SRC/$1" > "$DST/$2"; }

copy tmux/.tmux.conf            tmux/.tmux.conf
copy zsh/.zshrc                 zsh/.zshrc
copy zsh/.zprofile              zsh/.zprofile
copy zsh/.zshenv                zsh/.zshenv
copy zsh/.p10k.zsh              zsh/.p10k.zsh
copy sesh/.config/sesh/sesh.toml sesh/.config/sesh/sesh.toml

# Privacy guard: generic patterns for work / personal data.
# (.p10k.zsh is the generated Powerlevel10k theme; its example comments mention gke/emails.)
PATTERN='five9|gke|kubectl port-forward|get-credentials|VERTEX|/Users/[a-z]|@[a-z0-9-]+\.(com|io|net)|(api[_-]?key|token|secret|passw)[[:space:]]*='
if grep -rniE "$PATTERN" "$DST" --exclude=sync.sh --exclude=README.md --exclude=setup.sh --exclude=.p10k.zsh; then
  echo "sync.sh: possible private info above — move it to ~/.zshrc.local and re-run." >&2
  exit 1
fi
echo "Synced from $SRC → $DST (privacy check passed)"
