#!/bin/bash
export region=$1
export resolverid=$2

rm -f resolverupdate-$region.log
rm -f viewlistfull-$region.log
rm -f updatedpviews-$region.logfile

echo Looking for DNS views across compartments in $region
complistcur=$(cat complistid.file)
for compocid in $complistcur; do echo Enumerating DNS Private Views in $compocid && oci dns view list --compartment-id $compocid --region $region --all --scope PRIVATE --query 'data[?("is-protected")]' >> viewlistfull-$region.log ; done

rm -f viewlist.log
rm -f viewid-f.log

viewidlist=$(cat viewlistfull-$region.log | jq -r '.[] | ."id"')
echo "[" > viewlist.log
for viewid in $viewidlist; do echo {'"'viewId'"':'"'$viewid'"'}, >> viewlist.log ; done
echo "]" >> viewlist.log
echo $(cat viewlist.log) > viewid-f.log
sed -i 's/ //g' viewid-f.log
sed -i 's/'},]'/'}]'/g' viewid-f.log
export pvviewidlist=$(cat viewid-f.log)
echo $pvviewidlist
echo Updating resolver $region

rm -f updatedpviews-$region.logfile
oci dns resolver update --region $region --resolver-id $resolverid --attached-views $pvviewidlist --force > updatedpviews-$region.logfile
cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'

rm -f viewlist.log
rm -f viewid-f.log

dir=$(pwd)
echo $dir/viewlistfull-$region.log
echo $dir/updatedpviews-$region.logfile
