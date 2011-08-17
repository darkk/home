# ~/.bash_profile: executed by bash(1) for login shells.

# the default umask is set in /etc/login.defs
#umask 022

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
if [ -n "$BASH_VERSION" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi

export LANG="en_US.UTF-8"
