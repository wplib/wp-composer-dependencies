#!/usr/bin/env bash
#
#  scripts/compile.sh
#

#
# "Declare" all the variables here so PhpStorm won't complain about undeclared variables.
#
declare=${CIRCLE_ARTIFACTS:=}
declare=${CIRCLE_BRANCH:=}
declare=${SHARED_SCRIPTS:=}
declare=${REPO_ROOT:=}
declare=${GIT_REPO_ACCESS:=}

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/compile.log"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Announce general proccess
#
announce "Running Satis"

#
# Change to the repository root, just to be sure
#
announce "...Changing directory to ${REPO_ROOT}"
cd "${REPO_ROOT}"

#
# Pulling to ensure we run Satis on top of any external changes
#
announce "...Pulling from origin/${CIRCLE_BRANCH} to local ${CIRCLE_BRANCH}"
git pull origin ${CIRCLE_BRANCH} --quiet >> $ARTIFACTS_FILE

#
# Running Satis to build packages.json
#
announce "...Running Satis to build packages.json"
satis build --no-ansi --no-interaction --verbose satis.json > $ARTIFACTS_FILE 2>&1

#
# Check to see if we should munge packages.json to support
# direct Git repos as Composer repository vs. GitHub Pages
#
announce "...Check for 'public' or 'private' repository generation"
announce "...Generate ${GIT_REPO_ACCESS} repository"

if [ "private" == "${GIT_REPO_ACCESS}" ] ; then

    #
    # Capture .providers-url from packages.json
    #
    PACKAGES_JSON="${REPO_ROOT}/packages.json"
    announce "...Capture ['providers-url'] from ${PACKAGES_JSON}"
    PROVIDERS_URL="$(jq -r '.["providers-url"]' "${PACKAGES_JSON}")"

    #
    # Replace /p/ with /master/p/ in .providers-url
    #
    announce "...Replace '/p/' with '/master/p/' in ${PROVIDERS_URL}"
    PROVIDERS_URL="${PROVIDERS_URL/\/p\//\/master\/p\/}"
    announce "New PROVIDERS_URL: ${PROVIDERS_URL}"

    #
    # Updated providers-url in packages.json to include /master before /p
    # This is needed to support GitHub repos as a Composer repository
    #
    announce "...Update ['providers-url'] in ${PACKAGES_JSON} to ${PROVIDERS_URL}"
    PROVIDERS_URL="${PROVIDERS_URL/%/\%}"
    TEMP_FILE="$(mktemp jq-tmp.XXXX)" && \
        jq ".[\"providers-url\"] = \"${PROVIDERS_URL}\"" "${PACKAGES_JSON}" > $TEMP_FILE && \
        mv "${TEMP_FILE}" "${PACKAGES_JSON}"
fi

announce "Compile complete."