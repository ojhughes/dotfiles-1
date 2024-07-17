#!/usr/bin/env zsh

# PATHS

typeset -U PATH path
typeset -U MANPATH manpath
typeset -TU PKG_CONFIG_PATH pkg_config_path

# Setup GNU utilities and OpenSSL
# Note: intentionally skiping GNU libtool and make - breaks GYP
if (( ${+commands[brew]} )); then
  if [[ -n ${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/^(libtool|make)/libexec/gnubin(#qN) ]]; then
    path=(${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/^(libtool|make)/libexec/gnubin $path)
  fi

  if [[ -n ${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/^(libtool|make)/libexec/gnuman(#qN) ]]; then
    manpath=(${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/^(libtool|make)/libexec/gnuman $manpath)
  fi

  if [[ -n ${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/postgresql@15/bin(#qN) ]]; then
    postgresqlPath=${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/postgresql@15

    path=($postgresqlPath/bin $path)
    pkg_config_path=($postgresqlPath/pkgconfig $pkg_config_path)
  fi
fi

# Setup usage of VSCode from command line
path+="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Setup Android Studio development environment
export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=$HOME/Library/Android/sdk
path+=(
  $ANDROID_HOME/emulator
  $ANDROID_HOME/tools
  $ANDROID_HOME/tools/bin
  $ANDROID_HOME/platform-tools
)

# MISCELLANEOUS

# Set global configuration files for `git`
CURRENT_DIR="${"${(%):-%x}":A:h}"
export GIT_CONFIG_COUNT=2
export GIT_CONFIG_KEY_0=core.attributesFile
export GIT_CONFIG_VALUE_0=$(echo $CURRENT_DIR/../../git/.gitattributes(:A))
export GIT_CONFIG_KEY_1=core.excludesFile
export GIT_CONFIG_VALUE_1=$(echo $CURRENT_DIR/../../git/.gitignore(:A))


# Make VSCode the default editor for commands that support the $EDITOR variable
export EDITOR="code -w"
export KUBE_EDITOR="code -w"
export K9S_EDITOR="code -w"


# Avoid issues with `gpg` (installed via Homebrew)
# Ref: https://stackoverflow.com/a/42265848/96656
export GPG_TTY=$(tty)
