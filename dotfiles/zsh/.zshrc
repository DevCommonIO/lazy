# --------------------
# Powerlevel10k Instant Prompt
# --------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --------------------
# Oh My Zsh
# --------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  brew
  npm
  gradle
  gcloud
  zsh-completions
  zsh-history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --------------------
# Path helpers
# --------------------
path_add() { [[ -d "$1" ]] && path=("$1" $path) }
path_append() { [[ -d "$1" ]] && path=($path "$1") }

# --------------------
# NVM
# --------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# --------------------
# Java
# --------------------
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home"
path_add "$JAVA_HOME/bin"

# --------------------
# Android SDK
# --------------------
export ANDROID_HOME="$HOME/Library/Android/sdk"
path_append "$ANDROID_HOME/emulator"
path_append "$ANDROID_HOME/platform-tools"

# --------------------
# Python user binaries
# --------------------
path_add "$HOME/.local/bin"
path_add "$HOME/Library/Python/3.13/bin"

# --------------------
# Shell QoL
# --------------------
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# --------------------
# tmux helpers
# --------------------
alias tmxv="tmux split-window -h"
alias tmxh="tmux split-window -v"
alias ttab='tmux new-window -n'

# --------------------
# Cockroach helpers
# --------------------
cinit() { cockroach init --insecure }

cdb() {
  cockroach start --insecure \
    --store=node1 --listen-addr=localhost:26257 --http-addr=localhost:8080 --join=localhost:26257,localhost:26258,localhost:26259 --background
  cockroach start --insecure \
    --store=node2 --listen-addr=localhost:26258 --http-addr=localhost:8081 --join=localhost:26257,localhost:26258,localhost:26259 --background
  cockroach start --insecure \
    --store=node3 --listen-addr=localhost:26259 --http-addr=localhost:8082 --join=localhost:26257,localhost:26258,localhost:26259 --background
}

sql() { cockroach sql --insecure --url "postgres://root@localhost:26257/users" }


# --------------------
# Powerlevel10k Config
# --------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#


alias ta="tmux attach -t"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

alias tmxv="tmux split-window -h"
alias tmxh="tmux split-window -v"
alias ttab="tmux new-window -n"

alias tv="tmux new-session -A -s main"
# --------------------
# Auto-start tmux
# --------------------
# if command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
#   tmux attach-session -t main 2>/dev/null || tmux new-session -s main
# fi



export PATH=$PATH:$HOME/.maestro/bin
export GPG_TTY=$(tty)

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# --------------------
# zoxide (`z <dir>`; also feeds the sesh session picker)
# --------------------
eval "$(zoxide init zsh)"

# lazysql UI on the local CockroachDB started by `cdb` (insecure mode → no TLS)
alias ldb='lazysql "postgres://root@localhost:26257/users?sslmode=disable"'

# --------------------
# Machine / work-specific settings (NOT committed publicly)
# --------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
