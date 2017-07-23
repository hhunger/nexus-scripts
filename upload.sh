#!/usr/bin/env bash

#
# This script tries to upload a script found in src/main/groovy/ to a Nexus server located at NEXUS_HOST
#

checkIfExists() {
    retVal=`curl --write-out '%{http_code}' --silent -u admin:admin123 -X GET -o /dev/null ${NEXUS_API}/${SCRIPT_NAME}`
    if [[ ${retVal} == 200 ]]; then
        echo "Script '$SCRIPT_NAME' already exists"
        return 0
    fi
    return 1
}

delete() {
    echo "Deleting script '$SCRIPT_NAME'"
    retVal=`curl --write-out '%{http_code}' --silent -u admin:admin123 -X DELETE -o /dev/null ${NEXUS_API}/${SCRIPT_NAME}`
    if [[ ${retVal} == 204 ]]; then
        echo "Script '$SCRIPT_NAME' deleted"
        return 0
    fi
    echo "ERROR! Could not delete script '$SCRIPT_NAME'. HTTP code is $retVal"
    return 1
}

upload() {
    echo "Uploading script '$SCRIPT_NAME' form '$groovy_src'"
    script=`jshon -Qs "$(cat ${groovy_src})"`

    json="{\"name\": \"$SCRIPT_NAME\", \"type\": \"groovy\", \"content\": $script}"

    retVal=`curl --silent -u admin:admin123 --header "Content-Type: application/json" -d "$json" ${NEXUS_API}`
    if [[ ${retVal} == ERROR* ]] ; then
        echo "ERROR: Upload failed with error:"
        echo "---------------------------"
        echo "$retVal"
        echo "---------------------------"
        return 1
    fi
    echo "Upload successful"
    return 0
}

[ -z ${NEXUS_HOST} ] && NEXUS_HOST=localhost:8081

NEXUS_API=http://${NEXUS_HOST}/service/siesta/rest/v1/script

SCRIPT_NAME=$1
groovy_src=src/main/groovy/${SCRIPT_NAME}.groovy

if [ ! -f ${groovy_src} ] ; then
    echo "ERROR: Script '$groovy_src' not found!"
    exit 1
fi

if [ ! `which jshon` ] ; then
    echo "ERROR: jshon command not found. Please install 'jshon' package."
    exit 1
fi

echo "Connecting to Nexus at '$NEXUS_HOST'"

checkIfExists && delete
upload