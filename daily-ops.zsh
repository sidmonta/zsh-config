# ── Daily update check ──────────────────────────────────────────────────────
_ZSH_UPDATE_STAMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_last_update"
_ZSH_UPDATE_INTERVAL=$(( 60 * 60 * 24 ))   # 24h in secondi


_daily_update_check() {
  local now last=0
  now=$(date +%s)
  [[ -f "$_ZSH_UPDATE_STAMP" ]] && last=$(< "$_ZSH_UPDATE_STAMP")
  (( now - last < _ZSH_UPDATE_INTERVAL )) && return

  # Salva il timestamp subito: anche se il check fallisce, non riparte oggi
  mkdir -p "$(dirname "$_ZSH_UPDATE_STAMP")"
  print "$now" > "$_ZSH_UPDATE_STAMP"

  # Tutto in background: non rallenta l'avvio del terminale
  (
    local output="" has_updates=false

    # Homebrew
    if command -v brew &>/dev/null; then
      brew update --quiet 2>/dev/null
      local outdated; outdated=$(brew outdated 2>/dev/null)
      if [[ -n "$outdated" ]]; then
        has_updates=true
        output+=$'\n📦 Homebrew:\n'"$outdated"
      fi
    fi

    # npm global packages
    if command -v npm &>/dev/null; then
      local npm_out
      npm_out=$(npm outdated -g --parseable 2>/dev/null \
        | awk -F: '{split($NF,a,"@"); print a[1]}' \
        | paste -sd ', ')
      if [[ -n "$npm_out" ]]; then
        has_updates=true
        output+=$'\n📦 npm globals: '"$npm_out"
      fi
    fi

    # Custom upgrade check
    headroom update
    zplugin-update

    $has_updates && print "\n⚡ Aggiornamenti disponibili:$output\n"
  ) &!   # &! = disown: processo figlio completamente staccato
}

_daily_update_check
# ────────────────────────────────────────────────────────────────────────────
