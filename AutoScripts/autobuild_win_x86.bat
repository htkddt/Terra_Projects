@echo Creating windows package...
@echo OFF

set BUILD_CONFIG=Eval-standard
echo BUILD CONFIG is %BUILD_CONFIG%

set PATH=%PATH%;c:\Program Files\7-Zip;c:\Program Files (x86)\Subversion\bin
set PROJ_ROOT=%cd%
set ARENA=noc_dev

REM --------------------remove file containing the failure info. Existence of this file indicates the build failure.
del /q /s C:\AutoBuild\failed_build.txt

REM -------------------------------------------------------------------------------------------------------------------------------
REM 1. Update local folder for autobuild, folder mapped to svn://sccj017606.sc.intel.com/releases/automatic
REM 2. Create svn log file for log from last revision.
REM -------------------------------------------------------------------------------------------------------------------------------
cd /d c:\AutoBuild\
rmdir /q /s automatic
svn co svn://sccj017606.sc.intel.com/releases/automatic
@echo svn co for svn://sccj017606.sc.intel.com/releases/automatic done.
cd /d %PROJ_ROOT%/src/sw/%ARENA%/
del /q /s svn_info.txt
svn info > svn_info.txt
for /f "tokens=2" %%i in ('findstr Revision: svn_info.txt') do set REV=%%i
FOR /F "tokens=* delims=" %%x in (C:\AutoBuild\automatic\last_rev.txt) DO set LAST_REV= %%x
@echo ON
echo last svn rev is %LAST_REV%
svn log -r %LAST_REV%:%REV% > svn_log.txt
cd %PROJ_ROOT%
echo current svn revision is %REV%
@echo OFF

REM -------------------------------------------------------------------------------------------------------------------------------
REM 1. create build related directories.
REM 2. Build the code.
REM 3. zip the build using 7-zip. Log the build info in build_info.txt file
REM -------------------------------------------------------------------------------------------------------------------------------
set REL_DIR=Orion_win-x86_r%REV%
set FQDN_REL_DIR=%PROJ_ROOT%\%REL_DIR%
set EXAMPLES_STREAM=%PROJ_ROOT%\src\test_scripts\release\streaming
set EXAMPLES_AXI=%PROJ_ROOT%\src\test_scripts\release\axi
cd  %PROJ_ROOT%
echo current dir is %cd%
rmdir /q /s %FQDN_REL_DIR%
del /q %REL_DIR%.ZIP
cd /d %PROJ_ROOT%\src\sw\%ARENA%\prototype
echo Build is starting now.
msbuild NocStudio.vcxproj /p:Configuration=%BUILD_CONFIG%;Platform=Win32;Project=NocStudio /maxcpucount:4 /t:Rebuild > %PROJ_ROOT%\build_info.txt
REM ----------------------------------------------------------TO DO---------------------------------------------------------------------
REM 1. Check  build result.
REM 2. If build fails, log details to build_status.log file.
REM 3. Exit from script.
REM 4. Separate VB script will send email with build status and build log.
REM -------------------------------------------------------------------------------------------------------------------------------
set EXE_BUILD="FAILED"
cd %PROJ_ROOT%\src\sw\%ARENA%\
if exist NocStudio-eval-std.exe (
  set EXE_BUILD="SUCCESSFUL"
 )
echo NocStudio-eval-std.exe Build is %EXE_BUILD%
cd .\NocCore\%BUILD_CONFIG%\
echo current directory is %cd%
set LIB_BUILD="FAILED"
if exist NocCore.lib (
  set LIB_BUILD="SUCCESSFUL"
 )
echo NocCore Lib Build is %LIB_BUILD%

if %LIB_BUILD% EQU "FAILED" (
  GOTO FAILED_EXIT
) else (
  if %EXE_BUILD% EQU "FAILED" (
   GOTO FAILED_EXIT
  )
)

cd ..\..\prototype\

echo current ................ dir is %cd%
mkdir %FQDN_REL_DIR%
svn export --force %EXAMPLES_STREAM% %FQDN_REL_DIR%\examples
svn export --force %EXAMPLES_AXI% %FQDN_REL_DIR%\examples
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\noc_doc_images %FQDN_REL_DIR%\noc_doc_images
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\user_manual_files %FQDN_REL_DIR%\user_manual_files
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\custom_header.txt %FQDN_REL_DIR%\custom_header
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\nocinit.txt %FQDN_REL_DIR%\nocinit
cd %FQDN_REL_DIR%
7z x %PROJ_ROOT%\src\sw\distrib\win-runtime-x86.ZIP
copy %PROJ_ROOT%\src\sw\%ARENA%\NocStudio-eval-std.exe NocStudio.exe
mkdir tutorials
copy %PROJ_ROOT%\src\sw\%ARENA%\tutorials-amba\* tutorials\
copy %PROJ_ROOT%\src\sw\%ARENA%\tutorials-cc\* tutorials\
copy %PROJ_ROOT%\src\sw\%ARENA%\tutorials-lp\* tutorials\
copy %PROJ_ROOT%\src\sw\%ARENA%\tutorials-nsip\* tutorials\

cd %PROJ_ROOT%
echo Creating ZIP of release
7z a %REL_DIR%.ZIP %REL_DIR%
echo %PROJ_ROOT%\%REL_DIR%\
rmdir /Q /S %PROJ_ROOT%\%REL_DIR%\
systeminfo > sys_info.txt

REM -------------------------------------------------------------------------------------------------------------------------------
REM use date (YYYYMMDD) for folder name
REM -------------------------------------------------------------------------------------------------------------------------------

SETLOCAL EnableDelayedExpansion

    for /f "skip=1 tokens=1-6 delims= " %%a in ('wmic path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') do (
        IF NOT "%%~f"=="" (
            set /a FormattedDate=10000 * %%f + 100 * %%d + %%a
            set FormattedDate=!FormattedDate:~-2,2!/!FormattedDate:~-4,2!/!FormattedDate:~-6,2!
        )
    )
set name=20%FormattedDate:~6,2%%FormattedDate:~3,2%%DATE:~0,2%
@echo on
echo name of new folder is %name%
rmdir /q /s %name%
mkdir %name%

REM -------------------------------------------------------------------------------------------------------------------------------
REM ----------copy all the required files to %name% folder
REM -------------------------------------------------------------------------------------------------------------------------------

move %REL_DIR%.ZIP %name%\
move build_info.txt %name%\
move sys_info.txt %name%\
move src\sw\%ARENA%\svn_log.txt  %name%\
move src\sw\%ARENA%\svn_info.txt %name%\


cd %PROJ_ROOT%
echo  current dir is: %cd%
rmdir /q /s C:\AutoBuild\automatic\%name%
del /q /s C:\AutoBuild\automatic\last_rev.txt
echo %REV%>C:\AutoBuild\automatic\last_rev.txt
REM move %name% C:\AutoBuild\automatic\
cd /d C:\AutoBuild\automatic\

REM -------------------------------------------------------------------------------------------------------------------------------
REM Delete old builds from repository, keep last 2 builds and last_rev.txt file.
REM 1. Get list of all files in repository at given location
REM 2. save the list into file dir_file_list.txt
REM 3. REMOVE all files except last two builds and last_rev.txt file
REM -------------------------------------------------------------------------------------------------------------------------------
setlocal enabledelayedexpansion enableextensions
svn ls svn://sccj017606.sc.intel.com/releases/automatic >dir_file_list.txt
@echo off
set "file=dir_file_list.txt"
set /A i=0

for /F "usebackq delims=" %%a in ("%file%") do (
set /A i+=1
call echo %%i%%
call set array[%%i%%]=%%a
call set n=%%i%%
)
set /a n = n - 8
for /L %%i in (1,1,%n%) do call svn delete -m "deleting old build" svn://sccj017606.sc.intel.com/releases/automatic/%%array[%%i]%%

REM -- Done with using the file, delete it ----------------------------------------------------------------------------------------
del /q /s dir_file_list.txt


REM -------------------------------------------------------------------------------------------------------------------------------
REM Add newly added folder to svn and then commit.
REM -------------------------------------------------------------------------------------------------------------------------------
svn commit -m "Updated last_rev.txt file" last_rev.txt
cd /d %PROJ_ROOT%

svn import -m  "Created new trunk NocStudio binary for Windows." %name% svn://sccj017606.sc.intel.com/releases/automatic/%name%
rmdir /q /s %name%

echo Done with creating new build
echo current working dir is: %cd% 
echo Build completed Successfully.
REM get the autobuild folder again
rmdir /q /s C:\AutoBuild\automatic\
cd /d C:\AutoBuild\
echo getting the autobuild folder afresh from svn
svn co svn://sccj017606.sc.intel.com/releases/automatic
echo done with c:\AutoBuild\automatic checkout

GOTO CONTINUE

:FAILED_EXIT
 echo BUILD is Failed.
 copy %PROJ_ROOT%\build_info.txt C:\AutoBuild\failed_build.txt

:CONTINUE
 echo build details for %REL_DIR% is:>C:\AutoBuild\build_result.txt
 echo EXE_BUILD is %EXE_BUILD%>> C:\AutoBuild\build_result.txt
 echo LIB_BUILD is %LIB_BUILD%>> C:\AutoBuild\build_result.txt 



