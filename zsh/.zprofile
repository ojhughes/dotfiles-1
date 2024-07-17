# Disable filename expansion for `=`
setopt noequals

# Enable case-insensitive globing (used in pathname expansion)
setopt nocaseglob

# Enable extended globing for qualifiers
setopt extendedglob

# Use ~/.zshcustom as the ZSH_CUSTOM folder
export ZSH_CUSTOM=$HOME/.zshcustom

# Initialise paths
typeset -U PATH path

# Add `~/bin`, `~/.local/bin` and `/opt/starship/bin` to $PATH,
# ensures any binary dependencies of plugins get populated from Homebrew.
path=($HOME/bin $HOME/.local/bin /opt/starship/bin $path)

# Find Homebrew
if (( ! $+commands[brew] )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    export BREW_LOCATION="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    export BREW_LOCATION="/usr/local/bin/brew"
  fi
fi

# Load plugins
source $ZSH_CUSTOM/plugins/evalcache/evalcache.plugin.zsh
source $ZSH_CUSTOM/plugins/kubectl/kubectl.plugin.zsh
source $ZSH_CUSTOM/plugins/fasd/fasd.plugin.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZSH_CUSTOM/plugins/emacs/emacs.plugin.zsh
source $ZSH_CUSTOM/plugins/git/git.plugin.zsh

# Enable Homebrew
[[ -n $BREW_LOCATION ]] && _evalcache "$BREW_LOCATION" shellenv

# Load library files
for libraryFile ($ZSH_CUSTOM/*.zsh); do
  source $libraryFile
done
