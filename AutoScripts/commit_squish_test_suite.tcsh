#!/bin/tcsh

set CURRENT_PATH = `pwd`
set LOCAL_PATH = '/nfs/site/proj/CFG/scratch2/nguyentuanx/autoScript/tanmai'
set CFG_TUANX_PATH = '/nfs/site/proj/CFG/scratch2/nguyentuanx/cfg-netspeed'
set WEEK_NUMBER = `date +%W`
set YEAR_NUMBER = `date +%Y | tail -c 3`
set PRE_WEEK_NUMBER = `date -d "last week" +%W`
set PRE_YEAR_NUMBER = `date -d "last week" +%Y | tail -c 3`
set LOGFILE = "${YEAR_NUMBER}W${WEEK_NUMBER}.log"
source /nfs/site/proj/CFG/scratch2/nguyentuanx/autoScript/run.tcsh > $LOGFILE
cd $CURRENT_PATH
echo "Update squish test suite ${YEAR_NUMBER}W${WEEK_NUMBER}" | mail -s "Commit Automation Test Log" -a $LOGFILE tuanx.nguyen@intel.com sangx.phan@intel.com maix.tan@intel.com
