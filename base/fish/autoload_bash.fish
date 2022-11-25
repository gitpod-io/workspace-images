#!/usr/bin/env fish
if ! test -n "$AUTOLOAD_BASH_INJ"
    set -gx AUTOLOAD_BASH_INJ true
    exec bash -lic 'exec fish'
end
set -gu AUTOLOAD_BASH_INJ
