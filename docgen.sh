#!/bin/bash

if [ -n "${1}" -a "${1}" = "-h" ]; then
	echo "Usage: ${0} <version> <release>"
	exit 1
fi

if [ -z "${1}" ]; then
	VERSION="$(cat version)"
else
	VERSION="${1}"
fi

if [ -z "${2}" ]; then
	if [ "${VERSION}" = "$(cat version)" ]; then
		RELEASE="$(cat release)"
		if [[ "${RELEASE}" =~ ^b ]]; then
			beta="true"
			RELEASE="${RELEASE#b}"
		fi
		RELEASE=$((${RELEASE} + 1))
		if [ "${beta}" = "true" ]; then
			RELEASE="b${RELEASE}"
		fi
	else
		RELEASE="b0"
	fi
else
	RELEASE="${2}"
fi

BRANCH="$(cat branch)"

ls -a | grep -E "template$" | while read line; do
	cat ${line} | sed s/"\${VERSION}"/"${VERSION}"/g | sed s/"\${RELEASE}"/"${RELEASE}"/g > ${line%.template}
done

echo -n "${VERSION}" > version
echo -n "${RELEASE}" > release

git add docset.json ${BRANCH}.xml .travis.yml README.md dashing.json version release
git commit -m "${BRANCH}-${VERSION}-${RELEASE}"
git tag "${BRANCH}-${VERSION}-${RELEASE}"
git push --tags origin "${BRANCH}"