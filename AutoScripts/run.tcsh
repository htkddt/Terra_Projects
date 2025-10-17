#!/bin/tcsh

echo "==================================="
echo "Start commit automation test script"
echo "==================================="
echo ""
date

cd $CFG_TUANX_PATH
git clean -dxf
set CURRENT_BRANCH = `git branch | sed -n '/\* /s///p'`
if ($CURRENT_BRANCH == "master") then
    echo "Pull Latest Source Code"
    git pull
else
    echo "Not in Master branch"
    exit
endif

cd $LOCAL_PATH
git clean -dxf
git checkout .
git checkout master
git pull
set TAG = `git tag -l ${YEAR_NUMBER}W${WEEK_NUMBER}`
if ($TAG == "${YEAR_NUMBER}W${WEEK_NUMBER}") then
    echo "Tag ${TAG} exists."
else
    git tag -a ${YEAR_NUMBER}W$WEEK_NUMBER -m ${YEAR_NUMBER}W$WEEK_NUMBER
    set TAG = ${YEAR_NUMBER}W$WEEK_NUMBER
endif
git checkout ${TAG}

set TST_LIST = `git log --pretty=format:"- %s\n" ${PRE_YEAR_NUMBER}W$PRE_WEEK_NUMBER...${YEAR_NUMBER}W$WEEK_NUMBER`
cp -r $LOCAL_PATH/squish_test_suites_bdd/* $CFG_TUANX_PATH/squish_test_suites
git checkout master

cd $CFG_TUANX_PATH
##source /p/CFG/work0/share/env/cshrc.project
git status
cd squish_test_suites
git add .
git commit -m "Update squish test suite ${YEAR_NUMBER}W${WEEK_NUMBER}" -m "${TST_LIST}"
turnin -b master -comments "Update squish test suite ${YEAR_NUMBER}W${WEEK_NUMBER}"

echo ""
echo "================================="
echo "End commit automation test script"
echo "================================="

