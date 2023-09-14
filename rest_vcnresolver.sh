#!/bin/bash
export filename=$1.logfile 
export resocid=$1
saved_IFS=$IFS;
IFS="." tokens=( ${filename} )
export region=$(echo ${tokens[3]})
IFS=$saved
cat $filename | jq -r '.data | ."rules"' > $filename.rules.file
sed -i 's/client-address-conditions/clientAddressConditions/g' $filename.rules.file
sed -i 's/destination-addresses/destinationAddresses/g' $filename.rules.file
sed -i 's/qname-cover-conditions/qnameCoverConditions/g' $filename.rules.file
sed -i 's/source-endpoint-name/sourceEndpointName/g' $filename.rules.file
sed -i 's/source-endpoint-name/sourceEndpointName/g' $filename.rules.file

oci dns resolver update --region $region --resolver-id $resocid --rules file://$filename.rules.file --force >> $region-vcnresolverupdate.log
