#!/usr/bin/env bash
# Auto-start PostgreSQL server
(
	if mkdir /tmp/.pgsql_lock 2>/dev/null; then {
		target="${PGWORKSPACE}"
		source="${target//\/workspace/$HOME}"

		if test -e "$source"; then {

			if test ! -e "$target"; then {
				mv "$source" "$target"
			}; fi

			if ! [[ "$(pg_ctl status)" =~ PID ]]; then {
				pg_start >/dev/null
				trap "pg_stop" TERM EXIT
				exec {sfd}<> <(:)
				until read -r -t 3600 -u $sfd; do continue; done
			}; fi

		}; fi
	}; fi
) &
disown
