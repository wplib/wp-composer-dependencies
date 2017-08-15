#!/usr/bin/env bash
#
# scripts/deployment.sh
#

#
# "Declarations" of the variables this script assumes
#
declare=${CIRCLE_ARTIFACTS:=}
declare=${SHARED_SCRIPTS:=}
declare=${CIRCLE_BUILD_NUM:=}
declare=${REPO_ROOT:=}
declare=${CIRCLE_BRANCH:=}
declare=${BUILD_TAG:=}

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/deployment.log"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Announce general process
#
announce "Deploying updates back to repository"

#
# Change to the repository root, just to be sure
#
announce "...Changing directory to ${REPO_ROOT}"
cd "${REPO_ROOT}"

#
# Adding a BUILD file containing CIRCLE_BUILD_NUM
#
announce "...Adding a BUILD file containing build# ${CIRCLE_BUILD_NUM}"
echo "${CIRCLE_BUILD_NUM}" > ${REPO_ROOT}/BUILD

#
# Adding all files to Git stage
#
announce "...Staging all files except files excluded by .gitignore"
sudo git add .  >> $ARTIFACTS_FILE

#
# Committing files for this build
#
commitMsg="build #${CIRCLE_BUILD_NUM} [skip ci]"
announce "...Committing ${commitMsg}"
sudo git commit -m "Commit ${commitMsg}" >> $ARTIFACTS_FILE

#
# Pushing back to origin
#
announce "...Pushing to origin/${CIRCLE_BRANCH}"
git push origin ${CIRCLE_BRANCH} --quiet >> $ARTIFACTS_FILE

#
# Adding build tag
#
announce "...Tagging build with '${BUILD_TAG}'"
git tag -a "${BUILD_TAG}" -m "Build #${CIRCLE_BUILD_NUM}" 2>&1 >> $ARTIFACTS_FILE
onError

#
# Pushing build commit and tag
#
# @see https://stackoverflow.com/a/3745250/102699
#
announce "...Pushing tag ${BUILD_TAG}"
git push --tags --quiet >> $ARTIFACTS_FILE


announce "Deployment complete."
