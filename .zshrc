eval "$(/opt/homebrew/bin/brew shellenv)"

# =============================
# History
# =============================
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

# =============================
# Shell behavior
# =============================
setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT # sort file10 after file9, not after file1

# =============================
# Directory stack
# =============================
DIRSTACKSIZE=12
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

alias d='dirs -v | head -n 10'
for index ({1..9}) alias "$index"="cd +${index} >/dev/null"

# =============================
# Smart directory navigation
# =============================
# LF_ICONS=$(cat "$XDG_CONFIG_HOME/lf/icons" | tr '\n' ':')
# export LF_ICONS

eval "$(zoxide init zsh)"

# =============================
# Competition
# ===========================

# Load completion system (optimised: re-generate cache only once every 24h)
autoload -Uz compinit
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -f "$zcompdump" && -n "$(find "$zcompdump" -mtime +1)" ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

# Enable interactive completion menu selection
zstyle ':completion:*' menu select
# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# =============================
# Fuzzy finder
# =============================
export HOMEBREW_OPT="$HOMEBREW_PREFIX/opt"
if [[ -f "$HOMEBREW_OPT/fzf/shell/key-bindings.zsh" ]]; then
  source "$HOMEBREW_OPT/fzf/shell/key-bindings.zsh"
  source "$HOMEBREW_OPT/fzf/shell/completion.zsh"
fi


# =============================
# Modular configuration
# =============================
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/bindings.zsh"
source "$ZDOTDIR/prompt.zsh"


# =============================
# Environment variables
# =============================
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/vlc2-dkfjy2m4r7/Library/pnpm"
if [[ -n "$PNPM_HOME" ]]; then
  path+=("$PNPM_HOME")
fi
# pnpm end
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH=$HOME/.local/bin:$PATH

export ANTHROPIC_BASE_URL=http://127.0.0.1:8787
export OPENAI_BASE_URL=http://127.0.0.1:8787

# =============================
# Custom functions
# =============================
source "$ZDOTDIR/daily-ops.zsh"
