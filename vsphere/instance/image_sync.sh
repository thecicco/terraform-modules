#!/bin/bash

set -e
set -x

OUTPUT=$({

# Create folder if doesn't exist
if ! $(govc find -type f -name ${GOVC_FOLDER} | sed "s/\/${TEMPLATE_DC}\/vm\///g" | grep ^${GOVC_FOLDER}$ > /dev/null); then
  govc folder.create /${TEMPLATE_DC}/vm/${GOVC_FOLDER}
fi

if ! $(govc find -type f -name ${GOVC_FOLDER}/${FOLDER} | sed "s/\/${TEMPLATE_DC}\/vm\///g" | grep ^${GOVC_FOLDER}/${FOLDER}$ > /dev/null); then
  govc folder.create /${TEMPLATE_DC}/vm/${GOVC_FOLDER}/${FOLDER}
fi

EXISTING_TEMPLATE="$(govc find -type m -name "${TEMPLATE_NAME}" | head -n 1)"
if [ -n "${EXISTING_TEMPLATE}" ]; then
  echo ${TEMPLATE_NAME} already exist, skip image upload
  exit 0
fi

govc import.ova -dc="${TEMPLATE_DC}" -ds="${TEMPLATE_DS}" -pool="${TEMPLATE_POOL}" -name="${TEMPLATE_NAME}" "${TEMPLATE_URL}"
govc vm.markastemplate -dc="${TEMPLATE_DC}" "${TEMPLATE_NAME}"

})

OUTPUT=$(echo $OUTPUT | cut -c 1-20)
jq -r -n --arg template_name "${TEMPLATE_NAME}" --arg output "${OUTPUT}" --arg template_folder "${GOVC_FOLDER}" '{"template_name":$template_name,"template_folder":$template_folder,"output":$output}'
