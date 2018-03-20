#!/bin/bash

RESOURCE="${RESOURCE:-pod}"
SLEEP_INTERVAL="${SLEEP_INTERVAL:-1}"
USER="${USER:-admin}"
PASSWORD="${PASSWORD:-admin}"
BUNDLE_NAME="${BUNDLE_NAME:-dh-dynamic-apb}"
PARAMETER="${PARAMETER:-pods}"

oc login --insecure-skip-tls-verify ${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS} -u "${USER}" -p "${PASSWORD}"

current=$(oc get pods --no-headers | awk '{ print $1 }')
previous=$current
while true; do
    if [ "${current}" != "${previous}" ]; then
	previous=$(oc get "${RESOURCE}" --no-headers | awk '{ print $1 }')
	echo "Gathering bundle data..."
	bundle_id=$(oc get bundle -o custom-columns=Name:spec.fq_name,ID:metadata.name | grep ${BUNDLE_NAME} | awk '{ print $2 }')

	oc get bundle ${bundle_id} -o json > /opt/apb/bundle.json
	python /opt/apb/create-patch.py

	kubectl patch bundles ${bundle_id} --type merge --patch "$(cat /opt/apb/patch.json)"

	echo "Relist service catalog resources"
	apb relist
    fi
    sleep $SLEEP_INTERVAL
    current=$(oc get "${RESOURCE}" --no-headers | awk '{ print $1 }')
done
