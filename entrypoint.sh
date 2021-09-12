#!/bin/bash -e

{
    cd /repos

    if [ ! -d .repo ]; then
        repo init -u "${MANIFEST_URL}" -b "${MANIFEST_REVISION}" -m "${MANIFEST_NAME}" -g "${MANIFEST_GROUPS}" --mirror
    fi

    while true; do
        repo sync

        > cgitrepos
        while read -r line; do
            if ! [[ "${line}" =~ *".git" ]]; then
                line="${line}.git"
            fi
            echo "repo.url=${line}" >> cgitrepos
            echo "repo.path=/repos/${line}" >> cgitrepos
            echo "" >> cgitrepos
        done <<< "$(repo list -p)"

        sleep `expr 60 \* ${UPDATE_INTERVAL}`
    done
} &

exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
