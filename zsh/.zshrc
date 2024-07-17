[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
# Use the text that has already been typed as the prefix for searching through commands
# (i.e. enables a more intelligent Up/Down behavior)
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# Enable the Starship theme
_evalcache starship init zsh

# Initialize tools (with lazyload if possible)
(( $+commands[atuin] )) && _evalcache atuin init zsh
(( $+commands[mise] )) && _evalcache mise activate zsh
# (( $+commands[orbctl] )) && [[ -n $HOME/.orbstack/shell/init.zsh ]] && source $HOME/.orbstack/shell/init.zsh
# (( $+commands[rustup-init] )) && [[ -n $HOME/.cargo/env ]] && source $HOME/.cargo/env

# Load library files

# Initialise the auto-completion system to consume extra completions (for bash/zsh).
autoload -Uz bashcompinit
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  bashcompinit
	compinit
else
  bashcompinit -C
	compinit -C
fi
for libraryFile ($ZSH_CUSTOM/interactive/*.zsh); do
  source $libraryFile
done

# Load completion files
typeset -U FPATH fpath
if [[ -n $BREW_LOCATION ]]; then
  fpath=(${BREW_LOCATION:h:h}/share/zsh/site-functions $fpath)
fi
fpath=(
  $ZSH_CUSTOM/completions
  $ZSH_CUSTOM/plugins/zsh-completions/src
  $fpath
)

# Add tab completion for SSH hostnames based on ~/.ssh/config (ignoring wildcards)
[ -e $HOME/.ssh/config ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for frequently used apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Music Safari SystemUIServer Terminal" killall

plugins=(git fzf docker history-substring-search kubectl common-aliases gcloud kubectx zoxide emacs)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='emacs'
export GOPATH=$HOME/go
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
alias ak='goak'

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export GOROOT=$(brew --prefix go)/libexec
export PATH="/opt/homebrew/opt/make/libexec/gnubin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
setopt +o nomatch
source ~/.aliases
source ~/.ak_aliases
# source <(kubectl completion zsh)
source /opt/homebrew/opt/asdf/libexec/asdf.sh
eval `dircolors ~/.dircolors`
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# eval "$(zoxide init zsh)"
