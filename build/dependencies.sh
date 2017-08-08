#!/usr/bin/env bash
#
#  build/dependencies.sh
#

#
# "Declare" all the variables here so PhpStorm won't complain about undeclared variables.
#
declare=${CIRCLE_ARTIFACTS:=}
declare=${SHARED_SCRIPTS:=}
declare=${REPO_ROOT:=}
declare=${SATIS_DIR:=}
declare=${SATIS_SYMLINK:=}
declare=${SATIS_EXEC:=}
declare=${JQ_FILENAME:=}
declare=${USR_BIN:=}
declare=${JQ_FILEPATH:=}
declare=${FILES_ROOT:=}
declare=${SATIS_LOADER:=}

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
# Installing jq 1.5 so we can updates packages.json from command line
#
announce "Installing jq"
announce "...Moving ${JQ_FILEPATH} to ${USR_BIN}"
sudo mv "${JQ_FILEPATH}" "${USR_BIN}"
announce "...Renaming ${USR_BIN}/${JQ_FILENAME} to ${USR_BIN}/jq"
sudo mv "${USR_BIN}/${JQ_FILENAME}" "${USR_BIN}/jq"

#
# Change to home directory to cloning Satis does not screw up source repo
#
cd ~/

#
# Install Satis using Composer
#
if [ -d "${SATIS_DIR}" ] ; then
    announce "Satis already installed from cache"
else
    announce "Installing Satis"
    announce "...Creating directory ${SATIS_DIR} with 777 permissions"
    mkdir -p "${SATIS_DIR}" -m 777
    announce "...Chowning directory ${SATIS_DIR} to ubuntu:ubuntu"
    sudo chown ubuntu:ubuntu "${SATIS_DIR}"
    announce "...Creating Satis project using Composer"
    composer create-project composer/satis "${SATIS_DIR}" --stability=dev --keep-vcs
fi

#
# Install Satis Loader
#
announce "Installing Satis Loader"
announce "...Moving ${SATIS_LOADER} to ${USR_BIN}"
sudo mv "${SATIS_LOADER}" "${USR_BIN}"

#
# Symlinking Satis at /usr/local/bin/satis
#
announce "Symlinking Satis loader (${SATIS_LOADER}) to ${SATIS_SYMLINK}"
sudo ln -sf "${SATIS_LOADER}" "${SATIS_SYMLINK}"

