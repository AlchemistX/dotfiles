[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# Source
plug "${ZDOTDIR}/aliases.zsh"
plug "${ZDOTDIR}/exports.zsh"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-history-substring-search"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "agkozak/zsh-z"
plug "romkatv/powerlevel10k"
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

# History File
HISTFILE=${ZDOTDIR}/.zsh_history
