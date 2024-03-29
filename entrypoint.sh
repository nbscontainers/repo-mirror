#!/bin/bash -eu

cd /repos

if [ ! -d .repo ]; then
    repo init -u "${MANIFEST_URL}" -b "${MANIFEST_REVISION}" -m "${MANIFEST_NAME}" -g "${MANIFEST_GROUPS}" --mirror
else
    repo init -u "${MANIFEST_URL}" -b "${MANIFEST_REVISION}" -m "${MANIFEST_NAME}" -g "${MANIFEST_GROUPS}"
fi

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

    # Provide an alternative .git URL
    if ! [[ "${line_url}" =~ ^.*\.git$ ]]; then
        echo "repo.url=${line_url}.git" >> cgitrepos
        echo "repo.path=/repos/${line_path}" >> cgitrepos
        echo "repo.hide=1"  >> cgitrepos
        echo "" >> cgitrepos
    fi
done <<< "$(repo list)"
