#!/bin/bash
set -e

uid=$(stat -c %u /srv)
gid=$(stat -c %g /srv)

if [ "${uid}" -ne 0 ] || [ "${gid}" -ne 0 ]; then
    sed -i -r "s/baseuser:x:\d+:\d+:/baseuser:x:$uid:$gid:/g" /etc/passwd
    sed -i -r "s/basegroup:x:\d+:/basegroup:x:$gid:/g" /etc/group
    chown $uid:$gid /home

    if [ "${1}" != 'supervisord' ]; then
        exec su-exec baseuser "$@"
    fi
fi

exec "$@"
