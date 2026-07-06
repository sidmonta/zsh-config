# ~/.config/zsh/.zshenv

#----------- XDG base directories -----------
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export ZDOTDIR="$HOME/.config/zsh"


#----------- Editor -----------
export EDITOR="vim"
export VISUAL="code"

#----------- GPG -----------
export GPG_TTY=$(tty)

#----------- PATH (brew paths set in .zshrc after brew shellenv) -----------
export PATH="$HOME/.local/bin:$PATH"

#----------- Pager -----------
if command -v bat &> /dev/null; then
  export MANPAGER="bat -l man -p"
fi
