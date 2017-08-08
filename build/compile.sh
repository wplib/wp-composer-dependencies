#!/usr/bin/env bash
#
#  build/compile.sh
#

#
# "Declare" all the variables here so PhpStorm won't complain about undeclared variables.
#
declare=${CIRCLE_ARTIFACTS:=}
declare=${SHARED_SCRIPTS:=}
declare=${REPO_ROOT:=}

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/compile.log"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Change to the repository root, just to be sure
#
announce "Changing directory to ${REPO_ROOT}"
cd "${REPO_ROOT}"

#
# Running Satis to build packages.json
#
announce "Running Satis to build packages.json"
satis build satis.json 2>&1 > $ARTIFACTS_FILE

#
# Capture .providers-url from packages.json
#
PACKAGES_JSON="${REPO_ROOT}/packages.json"
announce "Capture ['providers-url'] from ${PACKAGES_JSON}"
PROVIDERS_URL="$(jq '.["providers-url"]' "${PACKAGES_JSON}")"


#
# Replace /p/ with /master/p/ in .providers-url
#
announce "Replaced '/p/' with '/master/p/' in ${PROVIDERS_URL}"
PROVIDERS_URL="${PROVIDERS_URL/\/p\//\/master\/p\/}"
announce "New PROVIDERS_URL: ${PROVIDERS_URL}"

#
# Updated providers-url in packages.json to include /master before /p
# This is needed to support GitHub repos as a Composer repository
#
announce "Updated ['providers-url'] in ${PACKAGES_JSON} to ${PROVIDERS_URL}"
TEMP_FILE="$(mktemp jq-tmp.XXXX)" && \
    jq ".[\"providers-url\"] = \"${PROVIDERS_URL}\"" "${PACKAGES_JSON}" > $TEMP_FILE && \
    mv "${TEMP_FILE}" "${PACKAGES_JSON}"

announce "Compile complete."