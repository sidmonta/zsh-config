#==========================
# Bindings
#==========================

# Reduce escape sequence timeout (centiseconds) — helps Alt/Ctrl+arrow work reliably
export KEYTIMEOUT=25

bindkey '^F' _fzf_file_no_hidden
bindkey '^\ ' autosuggest-toggle

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Enable mouse support (click to position cursor, shift+select to highlight)
zstyle ':zle:*' mouse yes

# Use emacs key bindings
bindkey -e

# Tab key behavior: accept autosuggestion if present, otherwise trigger completion
smart-tab-complete() {
  if (( ${+widgets[autosuggest-accept]} )) && [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle expand-or-complete
  fi
}
zle -N smart-tab-complete
bindkey -M emacs '^I' smart-tab-complete
bindkey -M viins '^I' smart-tab-complete

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history substring search if available, fallback to beginning search
if (( ${+widgets[history-substring-search-up]} )); then
  bindkey -M emacs "^[[A" history-substring-search-up
  bindkey -M viins "^[[A" history-substring-search-up
  bindkey -M vicmd "^[[A" history-substring-search-up
  if [[ -n "${terminfo[kcuu1]}" ]]; then
    bindkey -M emacs "${terminfo[kcuu1]}" history-substring-search-up
    bindkey -M viins "${terminfo[kcuu1]}" history-substring-search-up
    bindkey -M vicmd "${terminfo[kcuu1]}" history-substring-search-up
  fi
else
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey -M emacs "^[[A" up-line-or-beginning-search
  bindkey -M viins "^[[A" up-line-or-beginning-search
  bindkey -M vicmd "^[[A" up-line-or-beginning-search
  if [[ -n "${terminfo[kcuu1]}" ]]; then
    bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
  fi
fi

# Start typing + [Down-Arrow] - fuzzy find history substring search if available, fallback to beginning search
if (( ${+widgets[history-substring-search-down]} )); then
  bindkey -M emacs "^[[B" history-substring-search-down
  bindkey -M viins "^[[B" history-substring-search-down
  bindkey -M vicmd "^[[B" history-substring-search-down
  if [[ -n "${terminfo[kcud1]}" ]]; then
    bindkey -M emacs "${terminfo[kcud1]}" history-substring-search-down
    bindkey -M viins "${terminfo[kcud1]}" history-substring-search-down
    bindkey -M vicmd "${terminfo[kcud1]}" history-substring-search-down
  fi
else
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey -M emacs "^[[B" down-line-or-beginning-search
  bindkey -M viins "^[[B" down-line-or-beginning-search
  bindkey -M vicmd "^[[B" down-line-or-beginning-search
  if [[ -n "${terminfo[kcud1]}" ]]; then
    bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
  fi
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Cmd-Left] / [Cmd-Right] — macOS Terminal.app / iTerm2: inizio / fine riga
bindkey -M emacs '^[[H' beginning-of-line
bindkey -M viins '^[[H' beginning-of-line
bindkey -M emacs '^[[F' end-of-line
bindkey -M viins '^[[F' end-of-line

# Word / line deletion shortcuts
bindkey -M emacs '^[^?' backward-kill-word
bindkey -M viins '^[^?' backward-kill-word
bindkey -M emacs '^[^[[3~' kill-word
bindkey -M viins '^[^[[3~' kill-word
bindkey -M emacs '^U' kill-whole-line
bindkey -M viins '^U' kill-whole-line
bindkey -M emacs '^K' kill-line
bindkey -M viins '^K' kill-line
bindkey -M emacs '^[[3;9~' kill-line
bindkey -M viins '^[[3;9~' kill-line

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# [Alt-RightArrow] - move forward one word (Option+Right Arrow on Mac)
bindkey -M emacs '^[[1;3C' forward-word
bindkey -M emacs '^[^[[C' forward-word
bindkey -M emacs '^[f' forward-word

# [Alt-LeftArrow] - move backward one word (Option+Left Arrow on Mac)
bindkey -M emacs '^[[1;3D' backward-word
bindkey -M emacs '^[^[[D' backward-word
bindkey -M emacs '^[b' backward-word


bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' '^q ls\n'                            # [Esc-l] - run command: ls

# [Ctrl-r] - Search history (uses custom FZF widget if available)
if (( ${+widgets[fzf-history-widget-custom]} )); then
  bindkey '^r' fzf-history-widget-custom
else
  bindkey '^r' history-incremental-search-backward
fi

bindkey ' ' magic-space                               # [Space] - don't do history expansion


# Edit the current command line in $VISUAL (or $EDITOR / `vi` if not set)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

# Color definition for substring search matches
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=blue,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
