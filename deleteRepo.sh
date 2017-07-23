#!/usr/bin/env bash

[ -z ${NEXUS_HOST} ] && NEXUS_HOST=localhost:8081

NEXUS_API=http://${NEXUS_HOST}/service/siesta/rest/v1/script

REPO_NAME=$1

curl    -X POST \
        -u admin:admin123 \
        --header "Content-Type: text/plain" \
        -d '{"repo":"$REPO_NAME"}' \
        "http://localhost:8081/service/siesta/rest/v1/script/deleteRepo/run"
echo