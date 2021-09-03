call "C:\BDS\Studio\22.0\bin\rsvars.bat"
msbuild.exe "Source\FExplorer.dproj" /target:Clean;Build /p:Platform=Win64 /p:config=release
msbuild.exe "Source\FExplorer32.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release
msbuild.exe "Source\FEViewer.dproj" /target:Clean;Build /p:Platform=Win64 /p:config=release
msbuild.exe "Source\FEViewer.dproj" /target:Clean;Build /p:Platform=Win32 /p:config=release

call D:\ETHEA\Certificate\SignFileWithSectico.bat D:\ETHEA\FExplorer\Bin32\FEViewer.exe
call D:\ETHEA\Certificate\SignFileWithSectico.bat D:\ETHEA\FExplorer\Bin64\FEViewer.exe

:INNO
"C:\Program Files (x86)\Inno Setup 6\iscc.exe" "D:\ETHEA\FExplorer\Setup\FExplorer.iss"
set INNO_STATUS=%ERRORLEVEL%
if %INNO_STATUS%==0 GOTO SIGNSETUP
pause
EXIT

:SIGNSETUP
call D:\ETHEA\Certificate\SignFileWithSectico.bat D:\ETHEA\FExplorer\Setup\Output\FExplorerSetup.exe

:END
pause
