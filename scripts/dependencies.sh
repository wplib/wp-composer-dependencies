#!/usr/bin/env bash
#
#  scripts/dependencies.sh
#

#
# "Declare" all the variables here so PhpStorm won't complain about undeclared variables.
#
declare=${CIRCLE_ARTIFACTS:=}
declare=${SHARED_SCRIPTS:=}
declare=${REPO_ROOT:=}
declare=${SATIS_DIR:=}
declare=${SATIS_REPO:=}
declare=${SATIS_SYMLINK:=}
declare=${SATIS_EXEC:=}
declare=${JQ_FILENAME:=}
declare=${JQ_FILEPATH:=}
declare=${REPO_JQ:=}
declare=${USR_BIN:=}
declare=${FILES_ROOT:=}
declare=${LOADER_FILEPATH:=}
declare=${LOADER_FILENAME:=}
declare=${SATIS_LOADER:=}
declare=${GIT_USER_EMAIL:=}
declare=${CIRCLE_USERNAME:=}

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/dependencies.log"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Disabling this annoying SSH warning:
#
#       "Warning: Permanently added to the list of known hosts"
#
# @see https://stackoverflow.com/a/19733924/102699
#
announce "Disabling annoying SSH warnings"
sudo sed -i '1s/^/LogLevel ERROR\n\n/' ~/.ssh/config

#
# Setting git user.email
#
announce "Setting global Git user.email to ${GIT_USER_EMAIL}"
git config --global user.email "${GIT_USER_EMAIL}"
onError

#
# Setting git user.email
#
announce "Setting global Git user.name to ${CIRCLE_USERNAME}"
git config --global user.name "${CIRCLE_USERNAME}"
onError


#
# Installing jq 1.5 so we can updates packages.json from command line
#
announce "Installing jq"
announce "...Copying ${REPO_JQ} to ${USR_BIN}"
sudo cp "${REPO_JQ}" "${USR_BIN}"
announce "...Renaming ${JQ_FILEPATH} to ${USR_BIN}/jq"
sudo mv "${JQ_FILEPATH}" "${USR_BIN}/jq"

#
# Change to home directory to cloning Satis does not screw up source repo
#
cd ~/

#
# Install Satis using Composer
#
if [ -d "${SATIS_REPO}" ] ; then
    announce "Satis already installed from cache"
else
    announce "Installing Satis project using Composer"
    composer create-project composer/satis "${SATIS_REPO}" --stability=dev --keep-vcs --quiet 2>&1 > $ARTIFACTS_FILE
fi

#
# Install Satis using Composer
#
announce "Moving Satis"
announce "...Creating directory ${SATIS_DIR}"
sudo mkdir -p "${SATIS_DIR}"
announce "...Copying Satis from ${SATIS_REPO} to ${SATIS_DIR}"
sudo cp "${SATIS_REPO}/*" "${SATIS_DIR}"
announce "...Chowning directory ${SATIS_DIR} to ubuntu:ubuntu"
sudo chown ubuntu:ubuntu "${SATIS_DIR}"

#
# Install Satis Loader
#
announce "Installing Satis Loader"
announce "...Copying ${SATIS_LOADER} to ${USR_BIN}"
sudo cp "${SATIS_LOADER}" "${USR_BIN}"

#
# Symlinking Satis at /usr/local/bin/satis
#
announce "Symlinking Satis loader (${LOADER_FILEPATH}) to ${SATIS_SYMLINK}"
sudo ln -sf "${LOADER_FILEPATH}" "${SATIS_SYMLINK}"

