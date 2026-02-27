# ZSH Configs

export TERM=xterm-256color

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory        # Append new commands to the history file instead of overwriting it
setopt sharehistory         # Share history instantly across all running Zsh sessions
setopt hist_ignore_space    # Ignore commands that start with a space (don’t save them)
setopt hist_ignore_all_dups # Never save a command if it already exists anywhere in history
setopt hist_save_no_dups    # Don’t write duplicate commands to the history file
setopt hist_ignore_dups     # Don’t record a command if it’s the same as the previous one
setopt hist_find_no_dups    # Skip duplicates when searching history (Ctrl-R, arrow keys)
setopt beep extendedglob nomatch notify  # Enable beep, advanced globbing, error on unmatched globs, and job notifications
setopt correct              # Auto correct spelling errors
unsetopt autocd             # Disable auto‑cd so directory names don’t automatically change directories

# ZSH Plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='' 
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='' 

zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
 
# Keybindings
bindkey -e

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^n' history-substring-search-up
bindkey '^p' history-substring-search-down

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -A --color $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls -A --color $realpath'

# Shell Intergration
[[ "$TTY" != /dev/tty* ]] && eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# Aliases 
test -f ~/.aliases && . ~/.aliases

# Load Completions
autoload -Uz compinit
compinit

