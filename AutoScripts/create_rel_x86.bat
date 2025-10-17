@echo Creating windows package...

@echo OFF
REM -------------------------------------------------
set PROJ_ROOT=%cd%
set REL=trunk
set ARENA=noc_stable
set REL_DIR=Orion-Eval-%REL%-wn
REM -------------------------------------------------
set FQDN_REL_DIR=%PROJ_ROOT%\%REL_DIR%
set EXAMPLES_STREAM=%PROJ_ROOT%\src\test_scripts\release\streaming
set EXAMPLES_AXI=%PROJ_ROOT%\src\test_scripts\release\axi
set PATH=%PATH%;c:\Program Files\7-Zip;c:\Program Files (x86)\Subversion\bin
rmdir /q /s %FQDN_REL_DIR%
del /q %REL_DIR%.ZIP
@echo ON

cd %PROJ_ROOT%\src\sw\%ARENA%\prototype
msbuild NocStudio.vcxproj /p:Configuration=Eval-Standard;Platform=Win32;Project=NocStudio /maxcpucount:4
cd %PROJ_ROOT%

mkdir %FQDN_REL_DIR%
svn export --force %EXAMPLES_STREAM% %FQDN_REL_DIR%\examples
svn export --force %EXAMPLES_AXI% %FQDN_REL_DIR%\examples
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\noc_doc_images %FQDN_REL_DIR%\noc_doc_images
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\user_manual_files %FQDN_REL_DIR%\user_manual_files
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\custom_header.txt %FQDN_REL_DIR%\custom_header
svn export --force %PROJ_ROOT%\src\sw\%ARENA%\nocinit.txt %FQDN_REL_DIR%\nocinit

cd %FQDN_REL_DIR%

7z x %PROJ_ROOT%\src\sw\distrib\win-runtime-x86.ZIP
copy %PROJ_ROOT%\src\sw\%ARENA%\prototype\release\NocStudio-eval-std.exe .

cd %PROJ_ROOT%
@echo Creating ZIP of release
7z a %REL_DIR%.ZIP %REL_DIR%
