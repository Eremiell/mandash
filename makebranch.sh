#!/bin/bash

if [ -z "${1}" -o "${1}" = "-h" ]; then
	echo "Usage: ${0} <branch>"
	exit 1
fi

if [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ]; then
	echo "Run me on master."
	exit 2
fi

BRANCH="${1}"

git checkout -b "${BRANCH}"


ls -a | grep .generic | while read line; do
	cat ${line} | sed s/"\${BRANCH}"/"${BRANCH}"/g > $(echo ${line%.generic} | sed s/"\${BRANCH}"/"${BRANCH}"/)
done

echo -n "${BRANCH}" > branch