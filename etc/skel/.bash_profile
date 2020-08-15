# ~/.bash_profile: executed by bash at login.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Ensure we are running interactively

[[ $- != *i* ]] && return

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # include .bashrc if it exists
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
