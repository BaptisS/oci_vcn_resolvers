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
zip $tenancyname.vcnresolvers.$date.zip *backup.zip
rm -f *backup.zip
rm -f resolverslist-*.log
export dir=$(pwd)
echo $dir/$tenancyname.vcnresolvers.$date.zip

````
Restore vcnresolvers : 
````
#!/bin/sh

export backfile='vcnresolvers.2023-09-13.zip' ##--- must be updated
export date=$(date --iso-8601)
mkdir $date-vcnresolvers
mkdir $date-vcnresolvers/bak
cp $backfile $date-vcnresolvers/
cd $date-vcnresolvers/
unzip $backfile 
mv $backfile bak/
ls *.zip > files.list 
sed -i 's/.zip//g' files.list
dirs=$(cat files.list)
for dir in $dirs; do mkdir $dir && mkdir $dir/bak && mv $dir.zip $dir/ && cd $dir && unzip $dir.zip && mv $dir.zip bak/ && cd .. ; done
cd ..
rm -f files.list

#----
rm -f rest_vcnresolver.sh
wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/rest_vcnresolver.sh
chmod +x rest_vcnresolver.sh

ls *.logfile > resolversfiles.list
sed -i 's/.logfile//g' resolversfiles.list
reslist=$(cat resolversfiles.list)
for resolver in $reslist; do echo Restore VCN Resolver : $resolver && ./rest_vcnresolver.sh $resolver $region



````
