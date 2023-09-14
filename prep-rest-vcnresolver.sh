#!/bin/sh
#prep-rest-vcnresolver.sh
export dir=$1
export pathname=$2
mkdir $pathname/$region
mkdir $pathname/$region/bak
mv $pathname/$region.zip $pathname/$region/
unzip $pathname/$region/$region.zip -d unzip $pathname/$region/
mv $pathname/$region/$region.zip $pathname/$region/bak/

cd $pathname/$region/

rm -f rest_vcnresolver.sh
wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/rest_vcnresolver.sh
chmod +x rest_vcnresolver.sh

ls *.logfile > resolversfiles.list
sed -i 's/.logfile//g' resolversfiles.list
reslist=$(cat resolversfiles.list)
for resolver in $reslist; do echo Restore VCN Resolver : $resolver && ./rest_vcnresolver.sh $resolver $region ; done 
cd .. 
cd ..


