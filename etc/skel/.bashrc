#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export BASHRC="~/.bashrc"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If not running interactively, don't do anything
[[ $- != *i*  ]] && return

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#ensure the exports get loaded

if [ -f "$HOME/.config/bash/profiles/00-exports.bash" ]; then
    source "$HOME/.config/bash/profile/00-exports.bash"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Source System Bash

#Fedora/Redhat/CentOS
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

#Debian/Ubuntu/Arch
if [ -f /etc/bash.bashrc ]; then
    source /etc/bash.bashrc
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# source all others
if [ -f "$HOME/.config/bash/rc" ]; then
    source "$HOME/.config/bash/rc"
fi

#Local file
if [ -f "$HOME/.config/local/bash.local" ]; then
    source "$HOME/.config/local/bash.local"
fi

#System specific
if [ -f "$HOME/.config/local/bash."$(hostname -s)".local" ]; then
    source "$HOME/.config/local/bash."$(hostname -s)".local"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
