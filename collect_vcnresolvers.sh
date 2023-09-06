
#!/bin/sh
export region=$1
export tenancyname=$(oci iam compartment get --compartment-id $OCI_TENANCY | jq -r '.data | ."name"')

rm -f vcnresolverslist-$region-$tenancyname.log
rm -f vcnresolvers-$region-$tenancyname.log
rm -f vcnresolver-sh-$region-$tenancyname.csv


oci search resource structured-search --query-text "query dnsresolver resources" --region $region >> vcnresolverslist-$region-$tenancyname.log
vcnresolverslistcur=$(cat vcnresolverslist-$region-$tenancyname.log | jq .data |  jq .items | jq -r '.[] | ."identifier"')

for resolver in $vcnresolverslistcur; do oci dns resolver get --resolver-id $resolver --region $region >> vcnresolvers-$region-$tenancyname.log ; done

echo "[."display-name", ."id", ."endpoints"[]."is-listening", ."endpoints"[]."is-forwarding", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[], ."rules"[]."qname-cover-conditions"[] ]" >> vcnresolver-sh-$region-$tenancyname.csv
cat vcnresolvers-$region-$tenancyname.log | jq -r '.data | [ ."display-name", ."id", ."endpoints"[]."is-listening", ."endpoints"[]."is-forwarding", ."endpoints"[]."listening-address", ."endpoints"[]."forwarding-address", ."rules"[]."destination-addresses"[], ."rules"[]."qname-cover-conditions"[] ]  | @csv ' >> vcnresolver-sh-$region-$tenancyname.csv
cat vcnresolver-sh-$region-$tenancyname.csv >> vcnresolvers_allregions_$tenancyname.csv

export dir=$(pwd)
echo $dir/vcnresolvers_allregions_$tenancyname.csv

rm -f vcnresolverslist-$region-$tenancyname.log
rm -f vcnresolver-sh-$region-$tenancyname.csv
