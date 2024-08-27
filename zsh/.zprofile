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

HISTFILE=$HOME/.zsh_history
SAVEHIST=100000
HISTSIZE=99999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
HISTORY_SUBSTRING_SEARCH_FUZZY=true
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=true
# Load plugins
source $ZSH_CUSTOM/plugins/evalcache/evalcache.plugin.zsh
source $ZSH_CUSTOM/plugins/kubectl/kubectl.plugin.zsh
source $ZSH_CUSTOM/plugins/fasd/fasd.plugin.zsh
source $ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh
source $ZSH_CUSTOM/plugins/emacs/emacs.plugin.zsh
source $ZSH_CUSTOM/plugins/git/git.plugin.zsh
source $ZSH_CUSTOM/plugins/dircolors-neutral/dircolors-neutral.plugin.zsh

# Enable Homebrew
[[ -n $BREW_LOCATION ]] && _evalcache "$BREW_LOCATION" shellenv

# Load library files
for libraryFile ($ZSH_CUSTOM/*.zsh); do
  source $libraryFile
done

# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
