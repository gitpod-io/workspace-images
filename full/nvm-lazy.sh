#!/bin/bash

export NVM_DIR="$HOME/.nvm"

# Lazy load
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC2207,SC2038
    NODE_GLOBALS=($(find "$NVM_DIR/versions/node" -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq))
    NODE_GLOBALS+=("node")
    NODE_GLOBALS+=("nvm")

    # Lazy-loading nvm + npm on node globals
    load_nvm () {
        # shellcheck disable=SC1091,SC1090
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    }

    # Making node global trigger the lazy loading
    for cmd in "${NODE_GLOBALS[@]}"; do
        # shellcheck disable=SC2128
        eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
    done

    export PATH="$PATH:$HOME/.yarn/bin"
fi
