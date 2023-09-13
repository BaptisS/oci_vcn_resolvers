# oci_vcn_resolvers


````
#!/bin/sh
export tenancyname=$(oci iam compartment get --compartment-id $OCI_TENANCY | jq -r '.data | ."name"')
rm -f vcnresolvers_allregions_$tenancyname.csv
rm -f collect_vcnresolvers.sh

wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/collect_vcnresolvers.sh
chmod +x collect_vcnresolvers.sh

regionslist=$(oci iam region list)
regions=$(echo $regionslist | jq -r '.data[] | ."name"')
for region in $regions; do echo "Collecting DNS Private Resolvers Details in" $region && ./collect_vcnresolvers.sh $region ; done

rm -f collect_vcnresolvers.sh

export dir=$(pwd)
echo $dir/vcnresolvers_allregions_$tenancyname.csv


````

backup vcnresolvers : 
````
#!/bin/sh
export tenancyname=$(oci iam compartment get --compartment-id $OCI_TENANCY | jq -r '.data | ."name"')
rm -f back_vcnresolvers.sh
wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/back_vcnresolvers.sh
chmod +x back_vcnresolvers.sh

regionslist=$(oci iam region list)
regions=$(echo $regionslist | jq -r '.data[] | ."name"')
for region in $regions; do echo "Collecting DNS Private Resolvers Details in" $region && ./back_vcnresolvers.sh $region $tenancyname ; done

rm -f back_vcnresolvers.sh
export date=$(date --iso-8601)
zip $tenancyname.vcnresolvers.$date.zip *.zip
ll


````
