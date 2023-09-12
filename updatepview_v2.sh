#!/bin/bash
export region=$1
export resolverid01=$2
export resolverid02=$3
export resolverid03=$4
export resolverid04=$5

rm -f resolverupdate-$region.log
rm -f viewlistfull-$region.log
rm -f updatedpviews-$region.logfile

echo Looking for DNS views across compartments in $region
complistcur=$(cat complistid.file)
for compocid in $complistcur; do echo Enumerating DNS Private Views in $compocid && oci dns view list --compartment-id $compocid --region $region --all --scope PRIVATE --query 'data[?("is-protected")]' >> viewlistfull-$region.log ; done

rm -f viewlist.log
rm -f viewid-f.log

viewidnumber=$(cat viewlistfull-$region.log | jq -r '.[] | ."id"'| wc -l)
if [ $viewidnumber -le 49 ]; then  
#---------------
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
oci dns resolver update --region $region --resolver-id $resolverid01 --attached-views $pvviewidlist --force > updatedpviews-$region.logfile
cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'
rm -f viewlist.log
rm -f viewid-f.log
#---------------
;fi

if [ $viewidnumber -ge 50 ]; then  
#---------------
cat viewlistfull-$region.log | jq -r '.[] | ."id"' > viewidlistfull-$region.log
split -l 49 --numeric-suffixes viewidlistfull-$region.log viewidlistfull-$region.log
export viewlist01=$(cat viewidlistfull-$region.log00)
export viewlist02=$(cat viewidlistfull-$region.log01)
export viewlist03=$(cat viewidlistfull-$region.log02)
export viewlist04=$(cat viewidlistfull-$region.log03)

#--
export viewidlist=$viewlist01
export resolverid=$resolverid01
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
#--
#--
export viewidlist=$viewlist02
export resolverid=$resolverid02
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
#--
#--
export viewidlist=$viewlist03
export resolverid=$resolverid03
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
#--
#--
export viewidlist=$viewlist04
export resolverid=$resolverid04
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
#--
#---------------
;fi

dir=$(pwd)
echo $dir/viewlistfull-$region.log
echo $dir/updatedpviews-$region.logfile
