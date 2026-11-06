# Terminal dotfiles (iTerm2 + tmux + zsh + sesh)

The terminal side of this Neovim setup. Everything is built around one key-layer rule:

| Layer | Modifier | Used for |
|---|---|---|
| iTerm2 | `Cmd` | App-level things. `Cmd+D` / `Cmd+Shift+D` / `Cmd+h/j/k/l` are forwarded to tmux |
| tmux | `Alt`, prefix `Ctrl+Space` | Panes, windows, copy mode, sessions |
| Neovim | `Space` leader, `Ctrl` | Editing. `Alt+h/j/k/l` crosses nvim splits ↔ tmux panes (smart-splits.nvim) |

Daily keys: [`../DAILY.md`](../DAILY.md) (`<leader>H` in nvim) · full list: [`../SHORTCUTS.md`](../SHORTCUTS.md) (`<leader>?`).

## Contents

| Path | What |
|---|---|
| `tmux/.tmux.conf` | Prefix `C-Space`, `Alt+hjkl` / `Alt+arrows` aware of nvim, `Alt+v`/`Alt+s` splits, vi copy mode + pbcopy, sesh picker on `prefix f` |
| `zsh/` | `.zshrc` (oh-my-zsh + Powerlevel10k, zoxide), `.zprofile`, `.zshenv`, `.p10k.zsh` |
| `sesh/.config/sesh/sesh.toml` | Project sessions; new ones open nvim |
| `iterm2/setup.sh` | Applies the Cmd→tmux key forwarding, Option = Esc+, and "start tmux" to the default profile |
| `sync.sh` | Refreshes this copy from my private dotfiles repo with a privacy check |

`.zshrc` sources `~/.zshrc.local` at the end. Put machine- or work-specific stuff there; it's never committed.

## Install on a new Mac

```sh
brew install tmux neovim stow sesh fzf zoxide fd glow lazysql
git clone <this repo> ~/.config/nvim

cd ~/.config/nvim/dotfiles
stow -t ~ tmux zsh sesh          # symlinks ~/.tmux.conf, ~/.zshrc, ~/.config/sesh, ...
./iterm2/setup.sh                # then restart iTerm2
```

Also needed for `.zshrc`: [oh-my-zsh](https://ohmyz.sh), [powerlevel10k](https://github.com/romkatv/powerlevel10k), plus the `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-history-substring-search`, `zsh-completions` custom plugins.

## Updating this copy

```sh
~/.config/nvim/dotfiles/sync.sh   # copies from ~/dotfiles, replaces my home path with $HOME, aborts on private-looking content
```
