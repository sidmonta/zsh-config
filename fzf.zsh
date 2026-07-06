# ===================
# fzf
# ===================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude .cache --exclude .venv --exclude .next --exclude dist --exclude build --exclude .DS_Store --strip-cwd-prefix'

# Ctrl-T - Paste the selected files and directories onto the command line
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
export FZF_DEFAULT_OPTS='--height=60% --layout=reverse --border=rounded --color=dark --color=fg:#ffffff,bg:#193549,hl:#ffc600 --color=fg+:#ffffff,bg+:#1d3e5c,hl+:#ff9d00 --color=info:#ffc600,prompt:#ff9d00,pointer:#ff628c --color=marker:#3ad900,spinner:#9effff,header:#ffc600 --color=gutter:#193549,border:#9effff --info=inline --preview-window=right:60%:wrap'
export _FZF_PREVIEW_CMD='/opt/homebrew/bin/bat --color=always --style=plain,numbers --line-range :500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview '/opt/homebrew/bin/bat --color=always --style=plain,numbers --line-range :500 {}') \
    && LBUFFER+="${result}" \
    && zle reset-prompt
}
zle -N _fzf_file_no_hidden

# FZF history search (Ctrl-R) — pre-filtra con testo già scritto
fzf-history-widget-custom() {
  local selected query
  query="$BUFFER"
  BUFFER=
  selected=$(fc -rl 1 | fzf --height=80% --layout=reverse --border=rounded \
    --preview 'echo {2..}' --preview-window=top:2:wrap \
    --no-sort --tiebreak=index --query="$query") || return
  local num=$(echo "$selected" | awk '{print $1}')
  if [[ -n "$num" ]]; then
    zle vi-fetch-history -n "$num"
  fi
  zle reset-prompt
}
zle -N fzf-history-widget-custom

# Bind Ctrl-R to fzf history search
bindkey '^R' fzf-history-widget-custom
