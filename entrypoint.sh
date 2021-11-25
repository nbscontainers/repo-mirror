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
            line_split=(${line// : / })
            line_path=${line_split[0]}
            line_url=${line_split[1]}
            if ! [[ "${line_path}" =~ ^.*\.git$ ]]; then
                line_path="${line_path}.git"
            fi
            echo "repo.url=${line_url}" >> cgitrepos
            echo "repo.path=/repos/${line_path}" >> cgitrepos
            echo "" >> cgitrepos
        done <<< "$(repo list)"

        sleep `expr 60 \* ${UPDATE_INTERVAL}`
    done
} &

exec /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
