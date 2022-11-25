#!/bin/sh
if test ! -v AUTOLOAD_BASH_INJ; then
	export AUTOLOAD_BASH_INJ=true
	exec bash -lic 'exec zsh'
fi
unset AUTOLOAD_BASH_INJ
