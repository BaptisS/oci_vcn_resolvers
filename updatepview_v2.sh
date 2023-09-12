#!/bin/bash
export region=$1
export resolverid01=$2
export resolverid02=$3
export resolverid03=$4

rm -f resolverupdate-$region.log
rm -f viewlistfull-$region.bak
mv viewlistfull-$region.log viewlistfull-$region.bak
rm -f updatedpviews-$region.logfile

echo Looking for DNS views across compartments in $region
complistcur=$(cat complistid.file)
for compocid in $complistcur; do echo Enumerating DNS Private Views in $region $compocid && oci dns view list --compartment-id $compocid --region $region --all --scope PRIVATE --query 'data[?("is-protected")]' >> viewlistfull-$region.log ; done

rm -f viewlist.log
rm -f viewid-f.log

viewidnumber=$(cat viewlistfull-$region.log | jq -r '.[] | ."id"'| wc -l)
#---------------
if [ $viewidnumber -le 49 ]; then  
#---------------
rm -f updatedviews.log
cat viewlistfull-$region.log | jq -r '.[] | ."id"' > updatedviews.log
oci dns resolver get --region $region --resolver-id $resolverid01 | jq -r '.data."attached-views"[] | ."view-id"' >> updatedviews.log
cat updatedviews.log | sort | /usr/bin/uniq > updatedviews_u.log
viewidlist=$(cat updatedviews_u.log)
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
##oci dns resolver update --region $region --resolver-id $resolverid01 --attached-views $pvviewidlist --force > updatedpviews-$region.logfile
##cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'
rm -f viewlist.log
rm -f viewid-f.log
rm -f updatedviews.log
rm -f updatedviews_u.log
#---------------
elif [ $viewidnumber -ge 50 ]; then  
#---------------
cat viewlistfull-$region.log | jq -r '.[] | ."id"' > viewidlistfull-$region.log

rm -f updatedviews.log
cat viewlistfull-$region.log | jq -r '.[] | ."id"' > updatedviews.log
oci dns resolver get --region $region --resolver-id $resolverid01 | jq -r '.data."attached-views"[] | ."view-id"' >> updatedviews.log
oci dns resolver get --region $region --resolver-id $resolverid02 | jq -r '.data."attached-views"[] | ."view-id"' >> updatedviews.log
oci dns resolver get --region $region --resolver-id $resolverid03 | jq -r '.data."attached-views"[] | ."view-id"' >> updatedviews.log
#oci dns resolver get --region $region --resolver-id $resolverid04 | jq -r '.data."attached-views"[] | ."view-id"' >> updatedviews.log
cat updatedviews.log | sort | /usr/bin/uniq > updatedviews_u.log
split -l 49 --numeric-suffixes updatedviews_u.log viewidlistfull-$region.log

export viewlist01=$(cat viewidlistfull-$region.log00)
export viewlist02=$(cat viewidlistfull-$region.log01)
export viewlist03=$(cat viewidlistfull-$region.log02)
#export viewlist04=$(cat viewidlistfull-$region.log03)

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
##oci dns resolver update --region $region --resolver-id $resolverid --attached-views $pvviewidlist --force > updatedpviews-$region.logfile
##cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'
rm -f viewlist.log
rm -f viewid-f.log
rm -f updatedviews.log
rm -f updatedviews_u.log
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
##oci dns resolver update --region $region --resolver-id $resolverid --attached-views $pvviewidlist --force >> updatedpviews-$region.logfile
##cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'
rm -f viewlist.log
rm -f viewid-f.log
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
##oci dns resolver update --region $region --resolver-id $resolverid --attached-views $pvviewidlist --force >> updatedpviews-$region.logfile
##cat updatedpviews-$region.logfile | jq -r '.data | ."attached-views"'
rm -f viewlist.log
rm -f viewid-f.log
#---------------
fi

zip updatepview-$region.zip *.log*
rm -f *.log*
dir=$(pwd)
echo $dir/updatepview-$region.zip

