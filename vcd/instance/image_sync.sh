#!/bin/bash

set -e
set -x
TIMEOUT=300
LOCKFILE="$(basename $0).lock"
touch $LOCKFILE
exec {FD}<>$LOCKFILE
if ! flock -x $FD; then
	exit 1
else
  vcd login $VCD_URL $VCD_ORG $VCD_USERNAME > /dev/null
  # Create catalog if doesn't exist
  if [ $(vcd catalog info $CATALOG_NAME >/dev/null 2>&1; echo $?) == "2" ]; then
    vcd catalog create $CATALOG_NAME;
  fi
	EXIST=$(vcd catalog info $CATALOG_NAME $TEMPLATE_NAME 2>/dev/null |grep "template-id" )|| true

	if [[ $EXIST == "" ]]; then
		if $(wget -q $TEMPLATE_URL -O $TEMPLATE_NAME.ova > /dev/null); then
			vcd catalog upload $CATALOG_NAME $TEMPLATE_NAME.ova -i $TEMPLATE_NAME > /dev/null
			while [[ $STATUS != "RESOLVED" ]]
			do
				STATUS=$(vcd catalog list $CATALOG_NAME |grep  $TEMPLATE_NAME |awk '{print $6}')
				sleep 5
				COUNT=$[COUNT+5]
				if (( "$COUNT" > "$TIMEOUT" )); then
					jq -r -n --arg template_name "${TEMPLATE_NAME}" --arg output  "Warning: ${TEMPLATE_NAME} upload may be failed. Check for errors ( workaround for concurrent ovf tool upload)" '{"template_name":$template_name,"output":$output}'
					exit 1
				fi
			done
			jq -r -n --arg template_name "${TEMPLATE_NAME}" --arg output  "${TEMPLATE_NAME} uploaded successfully" '{"template_name":$template_name,"output":$output}'
			rm -f $TEMPLATE_NAME.ova
		else
			jq -r -n --arg template_name "${TEMPLATE_NAME}" --arg output  "Warning: ${TEMPLATE_NAME} upload may be failed. Check for errors ( workaround for concurrent ovf tool upload)" '{"template_name":$template_name,"output":$output}'
		fi
	else
		jq -r -n --arg template_name "${TEMPLATE_NAME}" --arg output  "${TEMPLATE_NAME} already exist" '{"template_name":$template_name,"output":$output}'
	fi
fi
