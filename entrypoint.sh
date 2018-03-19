#!/bin/bash

RESOURCE="${RESOURCE:-pod}"
SLEEP_INTERVAL="${SLEEP_INTERVAL:-1}"
USER="${USER:-admin}"
PASSWORD="${PASSWORD:-admin}"

oc login --insecure-skip-tls-verify ${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS} -u "${USER}" -p "${PASSWORD}"

current=$(oc get pods --no-headers | awk '{ print $1 }')
previous=$current
while true; do
    if [ "${current}" != "${previous}" ]; then
	previous=$(oc get "${RESOURCE}" --no-headers | awk '{ print $1 }')
	echo "Relist service catalog resources"
	apb relist
    fi
    sleep $SLEEP_INTERVAL
    current=$(oc get "${RESOURCE}" --no-headers | awk '{ print $1 }')
done
