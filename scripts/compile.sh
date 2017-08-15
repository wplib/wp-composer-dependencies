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
satis build satis.json --quiet 2>&1 > $ARTIFACTS_FILE

announce "Compile complete."