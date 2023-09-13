#!/bin/sh
export region=$1
oci search resource structured-search --query-text "query dnsresolver resources" --region $region >> resolverslist-$region.log
resolverslistcur=$(cat resolverslist-$region.log | jq .data |  jq .items | jq -r '.[] | ."identifier"')
for resolver in $resolverslistcur; do oci dns resolver get --resolver-id $resolver --region $region > $resolver.logfile && res_name=$(cat $resolver.logfile | jq -r '.data | ."display-name"') && echo Backing up vcn resolver : $res_name ; done
zip $region_vcnresolvers_backup.zip *.logfile
rm -f *.logfile
dir=$(pwd)
echo $dir/$region_vcnresolvers_backup.zip
