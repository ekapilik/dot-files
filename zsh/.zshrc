# Prompt
autoload -Uz promptinit
promptinit
prompt adam1

# History
setopt histignorealldups histignorespace sharehistory appendhistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Keybindings
bindkey -e

# Completion
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Colors
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# PATH
export PATH="${PATH}:/home/eric/dev/.scripts"
export PATH="$(npm prefix -g 2>/dev/null)/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# FZF
export FZF_DEFAULT_COMMAND='fd'

# WSL
export LIBGL_ALWAYS_SOFTWARE=1
export PULSE_SERVER=unix:/mnt/wslg/PulseServer

# WezTerm: emit OSC 7 on cwd change so Wezterm-Window-Tint retints live
_osc7_cwd() {
  printf '\e]7;file://%s%s\e\\' "${HOST:-localhost}" "$PWD"
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _osc7_cwd
add-zsh-hook precmd _osc7_cwd

# SSH agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi
if [ -z "$SSH_AUTH_SOCK" ]; then
  export SSH_AUTH_SOCK=$(find /tmp/ssh-* -type s 2>/dev/null | head -n 1)
fi
ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519 2>/dev/null

# Editor
alias nv='nvim'
alias v='nvim'

# Cargo
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'

# Misc
alias rb='glow -p'
alias cldev='claude --permission-mode acceptEdits "/good-dev"'
