#!/bin/sh
#prep-rest-vcnresolver.sh
export regfile=$1
export pathname=$2
mkdir $pathname/$regfile
mkdir $pathname/$regfile/bak
mv $pathname/$regfile.zip $pathname/$regfile/
unzip $pathname/$regfile/$regfile.zip -d unzip $pathname/$regfile/
mv $pathname/$regfile/$regfile.zip $pathname/$regfile/bak/

cd $pathname/$regfile/

rm -f rest_vcnresolver.sh
wget https://raw.githubusercontent.com/BaptisS/oci_vcn_resolvers/main/rest_vcnresolver.sh
chmod +x rest_vcnresolver.sh

ls *.logfile > resolversfiles.list
sed -i 's/.logfile//g' resolversfiles.list
reslist=$(cat resolversfiles.list)
for resolver in $reslist; do echo Restore VCN Resolver : $resolver && ./rest_vcnresolver.sh $resolver ; done 
cd .. 
cd ..


