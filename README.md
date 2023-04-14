# oci_vcn_resolvers


````
#!/bin/sh
rm -f vcnresolvers_allregions.log
rm -f collect_vcnresolvers.sh
wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/collect_vcnresolvers.sh
chmod +x collect_vcnresolvers.sh

regionslist=$(oci iam region list)
regions=$(echo $regionslist | jq -r '.data[] | ."name"')
for region in $regions; do echo "Collecting DNS Private Resolvers Details in" $region && ./collect_vcnresolvers.sh $region ; done
rm -f collect_vcnresolvers.sh
cat vcnresolvers_allregions.log

````

