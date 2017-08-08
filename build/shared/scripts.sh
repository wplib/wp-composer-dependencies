#!/usr/bin/env bash
#
# shared/scripts.sh - Includes files for source
#

declare=${CIRCLE_ARTIFACTS:=}

#
# Set artifacts file for this script
#
ARTIFACTS_FILE="${ARTIFACTS_FILE:="${CIRCLE_ARTIFACTS}/shared-scripts.log"}"

#
# Set an error trap. Uses an $ACTION variable.
#
ACTION=""
announce() {
    ACTION="$1"
    #
    # Escape slashes
    #
    ACTION="${ACTION/\//\\/}"
    echo -e "${ACTION}\n"
    echo -e "${ACTION}\n" >> $ARTIFACTS_FILE
}
onError() {
    if [ $? -ne 0 ] ; then
        printf "FAILED: ${ACTION}.\n"
        exit 1
    fi
}
trap onError ERR

#
# Making artifact subdirectory
#
announce "Creating artifact file ${ARTIFACTS_FILE}"
echo . > $ARTIFACTS_FILE
onError


