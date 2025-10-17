#!/bin/tcsh

set CURRENT_PATH = `pwd`
set LOCAL_PATH = '/nfs/site/proj/CFG/scratch2/nguyentuanx/autoScript/tanmai'
set CFG_TUANX_PATH = '/nfs/site/proj/CFG/scratch2/nguyentuanx/cfg-netspeed'
set WEEK_NUMBER = `date +%W`
set YEAR_NUMBER = `date +%Y | tail -c 3`
set PRE_WEEK_NUMBER = `date -d "last week" +%W`
set PRE_YEAR_NUMBER = `date -d "last week" +%Y | tail -c 3`

cd $LOCAL_PATH
git clean -dxf
git pull

set TAG = `git tag -l ${YEAR_NUMBER}W${WEEK_NUMBER}`
if ($TAG == "${YEAR_NUMBER}W${WEEK_NUMBER}") then
    echo "Tag ${TAG} exists."
else
    git tag -a ${YEAR_NUMBER}W$WEEK_NUMBER -m ${YEAR_NUMBER}W$WEEK_NUMBER
fi

set TST_LIST = `git log --pretty=format:"- %s\n" ${PRE_YEAR_NUMBER}W$PRE_WEEK_NUMBER...${YEAR_NUMBER}W$WEEK_NUMBER`
set add_cnt = `echo $TST_LIST | grep -i "create new" -c`
set fix_cnt = `echo $TST_LIST | grep -v -i "create new" | grep -i "-" -c`
echo "In this week:\n - Create new testcase: ${add_cnt}\n - Fix : ${fix_cnt}\n\n\n Here is the detail:\n ${TST_LIST}" | mail -s "Commit squish test suite ${YEAR_NUMBER}W${WEEK_NUMBER}" tuanx.nguyen@intel.com
