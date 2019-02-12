#!/bin/bash

set -e
TIMEOUT=300
vcd login https://admin.c2.kvdc.it ENTDDNQEP001 admin >/dev/null
EXIST=$(vcd catalog info $CATALOG_NAME $ISO_NAME 2>/dev/null |grep "template-id" )|| true

if [[ $EXIST != "" ]]; then
	vcd catalog delete -y $CATALOG_NAME $ISO_NAME > /dev/null
fi
EXIST=$(vcd catalog info $CATALOG_NAME $ISO_NAME 2>/dev/null |grep "template-id" )|| true
if [[ $EXIST == "" ]]; then
	if [ -e $ISO_PATH ]; then
        	vcd catalog upload $CATALOG_NAME $ISO_PATH -i $ISO_NAME > /dev/null
                while [[ $STATUS != "Resolved" ]]
                do
                	STATUS=$(vcd catalog info $CATALOG_NAME $ISO_NAME |grep "template-status" |awk '{print $2}')
                        sleep 5
                        COUNT=$[COUNT+5]
                        if (( "$COUNT" > "$TIMEOUT" )); then
                        	jq -r -n --arg template_name "${ISO_NAME}" --arg output  "Warning: ${ISO_NAME} upload may be failed. Check for errors ( workaround for concurrent ovf tool upload)" '{"template_name":$template_name,"output":$output}'
                                exit 1
                        fi
		done
                jq -r -n --arg template_name "${ISO_NAME}" --arg output  "${ISO_NAME} uploaded successfully" '{"template_name":$template_name,"output":$output}'
	else
		jq -r -n --arg template_name "${ISO_NAME}" --arg output  "Warning: ${ISO_NAME} upload may be failed. Check for errors ( workaround for concurrent ovf tool upload)" '{"template_name":$template_name,"output":$output}'
	fi
fi
