[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "agkozak/zsh-z"
plug "chivalryq/git-alias"

# Changing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# History Setup
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Load and initialise completion system
autoload -Uz compinit
compinit

# History File
HISTFILE=${ZDOTDIR}/.zsh_history

if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# (Option #1) Enable Starship
eval "$(starship init zsh)"

# (Option #2) Enable P10K
#plug "romkatv/powerlevel10k"

# Source
plug "${ZDOTDIR}/aliases.zsh"
plug "${ZDOTDIR}/exports.zsh"
