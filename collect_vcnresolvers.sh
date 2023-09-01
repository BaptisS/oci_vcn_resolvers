#!/bin/sh
export region=$1

rm -f vcnlist-$region.log
rm -f vcnresolverslist-$region.log
rm -f vcnresolvers-$region.log
rm -f vcnresolvers-sh-$region.log

oci search resource structured-search --query-text "query vcn resources" --region $region >> vcnlist-$region.log
vcnlistcur=$(cat vcnlist-$region.log | jq .data |  jq .items | jq -r '.[] | ."identifier"')

for vcn in $vcnlistcur; do oci network vcn-dns-resolver-association get --vcn-id $vcn --region $region --query "data.[\"dns-resolver-id\"]" | jq -r '.[]' >> vcnresolverslist-$region.log ; done
vcnresolverslistcur=$(cat vcnresolverslist-$region.log)
for resolver in $vcnresolverslistcur; do oci dns resolver get --resolver-id $resolver --region $region >> vcnresolvers-$region.log ; done

echo "[."display-name", ."id", ."endpoints"[]."is-listening", ."endpoints"[]."is-forwarding", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[], ."rules"[]."qname-cover-conditions"[] ]" >> vcnresolver-sh-$region.log
cat vcnresolvers-$region.log | jq -r '.data | [ ."display-name", ."id", ."endpoints"[]."is-listening", ."endpoints"[]."is-forwarding", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[], ."rules"[]."qname-cover-conditions"[] ]  | @csv ' >> vcnresolver-sh-$region.log
cat vcnresolver-sh-$region.log >> vcnresolvers_allregions.log

export dir=$(pwd)
echo $dir/vcnresolvers_allregions.log

rm -f vcnlist-$region.log
rm -f vcnresolverslist-$region.log
#rm -f vcnresolvers-$region.log
rm -f vcnresolver-sh-$region.log
