# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

########################################################################
# Set up environment

function dedupe {
	echo "$1" | tr : '\n' | uniq | tr '\n' : | sed 's/:*$//'
}

function mkpath {
	local ifs="$IFS"
	local newpath=""
	IFS=:
	for elem in $PATH; do
		local sbin="${elem/%\/bin//sbin}"
		if [ -d "$sbin" ]; then
			newpath="$newpath:$sbin"
		fi
		newpath="$newpath:$elem"
	done
	IFS="$ifs"
	export PATH=$(dedupe "${newpath:1}")
}

if [ -d "$HOME/build/django" ]; then
	export PYTHONPATH=$(dedupe "$HOME/build/django:$PYTHONPATH")
fi
export PYTHONSTARTUP=$HOME/.config/python/initialize.py

export EDITOR=vim
export VISUAL=vim
export PAGER=less

export ECHANGELOG_USER="Leonid Evdokimov (darkk) <leon@darkk.net.ru>"

export HISTCONTROL=ignoredups

# Perl module `Test` uses this variable.
export PERL_TEST_DIFF="diff -u"

# See https://help.ubuntu.com/community/ComposeKey
# without `xim` GTK uses hardcoded Compose sequences
export GTK_IM_MODULE="xim"

# that makes `ls` colorful on FreeBSD
export CLICOLOR=1

[[ -d ~/bin ]] && PATH=~/bin:$PATH
mkpath

unset mkpath dedupe


########################################################################
# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi


########################################################################
# Put your fun stuff here.

alias cal="cal -m"
alias j=jobs

if [[ "$TERM" = "xterm" ]] && [[ "$LANG" = *.UTF-8 ]]; then
    # putty needs it to enable utf-8
    echo -ne '\e%G'
fi

# vim:set softtabstop=4 expandtab:
