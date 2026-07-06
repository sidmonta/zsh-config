alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -lah --icons --git --group-directories-first'

alias tree='eza --tree --icons'

compdef eza=ls

alias cat='bat --style=plain,numbers --color=always'

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# AI Related
alias clean-ai="ls -t ~/.claude/sessions | tail -n +20 | xargs rm -rf && ls -t ~/.copilot/session-state/ | tail -n +20 | xargs rm -rf && rm -rf ~/.claude/cache/* && ls .gemini/tmp/ | tail -n +20 | xargs rm -rf"
alias opencode="headroom wrap opencode"
alias gemini="agy"

# Create a directory and enter it immediately
mkcd() { mkdir -p "$1" && cd "$1" }

# cd .., cd ..., cd ...., ... -> go up N-1 levels
cd() {
  if (( $# == 1 )) && [[ -n "$1" && ${1//.} == '' && ${#1} -gt 1 ]]; then
    local up=$(( ${#1} - 1 ))
    local target='..'
    local i

    for (( i = 2; i <= up; i++ )); do
      target+='/..'
    done

    builtin cd -- "$target"
  else
    builtin cd "$@"
  fi
}

# Network utilities
alias myip="ipconfig getifaddr en0 || ipconfig getifaddr en1"
alias mypublicip="curl -s ifconfig.me"
alias ports="lsof -iTCP -sTCP:LISTEN -P -n"

# Copy files or path directly to clipboard (macOS)
alias copypath="pwd | tr -d '\n' | pbcopy"
alias copyfile="pbcopy <"

# Safety confirmations
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
