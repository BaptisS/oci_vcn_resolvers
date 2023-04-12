# oci_vcn_resolvers


````
#!/bin/sh
rm -f vcnresolvers_allregions.log

export region=<region>

rm -f vcnlist-$region.log
rm -f vcnresolverslist-$region.log
rm -f vcnresolvers-$region.log
rm -f vcnresolvers-short-$region.log
rm -f vcnresolver-sh-$region.log

oci search resource structured-search --query-text "query vcn resources" --region $region >> vcnlist-$region.log
vcnlistcur=$(cat vcnlist-$region.log | jq .data |  jq .items | jq -r '.[] | ."identifier"')

for vcn in $vcnlistcur; do oci network vcn-dns-resolver-association get --vcn-id $vcn --region $region --query "data.[\"dns-resolver-id\"]" | jq -r '.[]' >> vcnresolverslist-$region.log ; done
vcnresolverslistcur=$(cat vcnresolverslist-$region.log)
for resolver in $vcnresolverslistcur; do oci dns resolver get --resolver-id $resolver --region $region >> vcnresolvers-$region.log ; done

echo "LM, Resolver Name, ocid, ListenerIP, ForwarderIP, RulesTargetIP(s)" > vcnresolver-sh.log
cat vcnresolvers-$region.log | jq -r '.[] | [."freeform-tags"."lm", ."display-name", ."id", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[] ]  | @csv ' >> vcnresolver-sh-$region.log
cat vcnresolver-sh-$region.log >> vcnresolvers_allregions.log

````



````
#!/bin/sh
complist=$(oci iam compartment list --all --compartment-id-in-subtree true) 
complistcur=$(echo $complist | jq .data | jq -r '.[] | ."id"')
rm -f vcnlist.log
rm -f vcnresolverslist.log
rm -f vcnresolvers.log
rm -f vcnresolvers-short.log

for compocid in $complistcur; do oci network vcn list --compartment-id $compocid --all >> vcnlist.log ; done
vcnlistcur=$(cat vcnlist.log | jq .data | jq -r '.[] | ."id"')
for vcn in $vcnlistcur; do oci network vcn-dns-resolver-association get --vcn-id $vcn --query "data.[\"dns-resolver-id\"]" | jq -r '.[]' >> vcnresolverslist.log ; done
vcnresolverslistcur=$(cat vcnresolverslist.log)
for resolver in $vcnresolverslistcur; do oci dns resolver get --resolver-id $resolver >> vcnresolvers.log ; done

echo "Resolver Name, ocid, ListenerIP, ForwarderIP, RulesTargetIP(s)" > vcnresolver-sh.log
cat vcnresolvers.log | jq -r '.[] | [."display-name", ."id", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[] ]  | @csv ' >> vcnresolver-sh.log
cat vcnresolver-sh.log
