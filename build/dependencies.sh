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

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${CIRCLE_ARTIFACTS}/dependencies.log"

#
# Load the shared scripts
#
source "${SHARED_SCRIPTS}"

#
# Installing jq so we can updates packages.json from command line
#
announce "Installing jq"
sudo apt-get install jq

#
# Change to home directory to cloning Satis does not screw up source repo
#
cd ~/

#
# Install Satis using Composer
#
announce "Installing Satis using Composer"
composer create-project composer/satis --stability=dev --keep-vcs

#
# Moving Satis to /usr/local/bin/satis.dir
#
announce "Moving Satis to ${SATIS_DIR}"
sudo mv satis /usr/local/bin/satis-php

#
# Symlinking Satis at /usr/local/bin/satis
#
announce "Symlinking Satis at ${SATIS_SYMLINK}"
sudo ln -sf "${SATIS_DIR}/bin/satis" "${SATIS_SYMLINK}"

