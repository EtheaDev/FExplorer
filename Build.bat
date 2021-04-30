call "C:\BDS\Studio\21.0\bin\rsvars.bat"
msbuild.exe "Source\FExplorer.dproj" /target:Clean;Build /p:Platform=Win64 /p:config=release
msbuild.exe "Source\FExplorer32.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release
msbuild.exe "Source\FEViewer.dproj" /target:Clean;Build /p:Platform=Win64 /p:config=release
msbuild.exe "Source\FEViewer.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release

:INNO
"C:\Program Files (x86)\Inno Setup 6\iscc.exe" "D:\ETHEA\FExplorer\Setup\FExplorer.iss"
set INNO_STATUS=%ERRORLEVEL%
if %INNO_STATUS%==0 GOTO END
pause
EXIT

:END
pause
