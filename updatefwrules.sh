#!/bin/sh
export res_region=$1
export res_ocid=$2
export res_excl=$3
export fw_domains=$4 
export fw_target=$5

rm -f $res_ocid.logfile
if [[ "$res_ocid" != "$res_excl" ]]; then
export fw_ep_name=$(oci dns resolver get --region $res_region --resolver-id $res_ocid | jq -r '.data.endpoints[] | ."name"')
export fw_rules='[{"action":"FORWARD","qnameCoverConditions":['$fw_domains'],"destinationAddresses":["'$fw_target'"],"sourceEndpointName":"'$fw_ep_name'"}]'
oci dns resolver update --region $res_region --resolver-id $res_ocid --rules $fw_rules --force >> $res_ocid.logfile
echo done
fi

