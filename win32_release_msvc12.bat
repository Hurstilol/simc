:: Necessary Qt dlls are packaged with every release.
:: These dlls are not included in the GIT.
:: They need to be copied into the dev area from the Qt install.
:: Qt-Framework is simply the Qt runtime dlls built against the MSVC 2013 compiler
:: It can be found at: http://qt-project.org/downloads
:: If you build SimC with MSVC 2013, then you need to use dlls from Qt-Framework
:: As of this writing, the default locations from which to gather the dlls are:
:: Qt-Framework: C:\Qt\Qt5.4.0\

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%a-%%b)

set install=simc-603-18-win32
set redist="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\redist\x86\Microsoft.VC120.CRT"

:: IMPORTANT NOTE FOR DEBUGGING
:: This script will ONLY copy the optimized Qt dlls
:: The MSVC 2013 simcqt.vcproj file is setup to use optimized dlls for both Debug/Release builds
:: This script needs to be smarter if you wish to use the interactive debugger in the Qt SDK
:: The debug Qt dlls are named: Qt___d5.dll

:: Delete old folder/files
rd %install% /s /q
rd QTLib /s /q 

for /f "skip=2 tokens=2,*" %%A in ('reg.exe query "HKLM\SOFTWARE\Microsoft\MSBuild\ToolsVersions\12.0" /v MSBuildToolsPath') do SET MSBUILDDIR=%%B

"%MSBUILDDIR%msbuild.exe" E:\simulationcraft\simc_vs2013.sln /p:configuration=release /p:platform=win32 /nr:true /m:8
forfiles -s -m generate_????.simc -c "cmd /c echo Running @path && %~dp0simc.exe @file"
windeployqt --release --no-translations --no-compiler-runtime --dir Plugins simulationcraft.exe

xcopy %redist%\msvcp120.dll %install%\
xcopy %redist%\msvcr120.dll %install%\
xcopy %redist%\vccorlib120.dll %install%\
xcopy Welcome.html %install%\
xcopy Welcome.png %install%\
xcopy Simulationcraft.exe %install%\
xcopy simc.exe %install%\
xcopy readme.txt %install%\
xcopy Error.html %install%\
xcopy COPYING %install%\
xcopy Profiles %install%\profiles\ /s /e
xcopy Plugins %install%\Plugins\ /s /e
xcopy C:\OpenSSL-Win32\bin\libeay32.dll %install%\
xcopy C:\OpenSSL-Win32\bin\ssleay32.dll %install%\