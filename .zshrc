#!/bin/zsh

#######################################################
# SOURCED ALIAS'S AND SCRIPTS by zachbrowne.me
#######################################################

# Source global definitions (If applicable to Zsh)
if [ -f /etc/zshrc ]; then
	 . /etc/zshrc
fi

# Zsh specific configurations

#######################################################
# EXPORTS
#######################################################

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth

# Automatically trim long paths in the prompt (requires prompt theme support)
export PROMPT_DIRTRIM=2

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim

# Alias definitions, replace 'batcat' with 'bat' on macOS if installed
if command -v bat > /dev/null; then
    alias cat='bat'
fi

# Color support for 'ls'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# To have colors for grep commands
alias grep='grep --color=auto'

# Man pages color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

alias web='cd /var/www/html'

#######################################################
# GENERAL ALIAS'S
#######################################################

alias da='date "+%Y-%m-%d %A %T %Z"'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 5'
alias less='less -R'
alias cls='clear'
alias ll='ls -lFh'
alias la='ls -AFh'
alias l='ls -CF'

#######################################################
# FUNCTIONS
#######################################################

edit() {
    if command -v nvim > /dev/null; then
        nvim "$@"
    else
        vim "$@"
    fi
}

sedit() {
    if command -v nvim > /dev/null; then
        sudo nvim "$@"
    else
        sudo vim "$@"
    fi
}

# Function to extract archives
extract() {
     if [ -f $1 ]; then
         case $1 in
             *.tar.bz2)   tar xjf $1     ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1     ;;
             *.rar)       unrar x $1     ;;
             *.gz)        gunzip $1      ;;
             *.tar)       tar xf $1      ;;
             *.tbz2)      tar xjf $1     ;;
             *.tgz)       tar xzf $1     ;;
             *.zip)       unzip $1       ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1        ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#######################################################
# Starship Prompt
#######################################################

# Install Starship - curl -sS https://starship.rs/install.sh | sh

eval "$(starship init zsh)"

#######################################################
# Autojump
#######################################################

if [ -f /usr/local/etc/profile.d/autojump.sh ]; then
    . /usr/local/etc/profile.d/autojump.sh
elif [ -f $(brew --prefix)/etc/profile.d/autojump.sh ]; then
    . $(brew --prefix)/etc/profile.d/autojump.sh
else
    echo "Autojump script not found."
fi
