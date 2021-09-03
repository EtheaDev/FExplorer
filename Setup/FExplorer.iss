; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!
#define MyAppName 'FExplorer (Fattura Elettronica Explorer e Visualizzatore)'
#define MyAppVersion '1.7.0'

[Setup]
AppName={#MyAppName}
AppPublisher=Ethea S.r.l.
AppVerName={#MyAppName} {#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
AppPublisherURL=https://www.ethea.it/
AppSupportURL=https://github.com/EtheaDev/FExplorer/issues
DefaultDirName={pf}\Ethea\FExplorer
OutputBaseFileName=FExplorerSetup
DisableDirPage=false
DefaultGroupName=FExplorer
Compression=lzma
SolidCompression=true
UsePreviousAppDir=false
AppendDefaultDirName=false
PrivilegesRequired=admin
WindowVisible=false
WizardImageFile=WizEtheaImage.bmp
WizardSmallImageFile=WizEtheaSmallImage.bmp
AppContact=info@ethea.it
SetupIconFile=..\Icons\setup.ico
AppID=FExplorer
UsePreviousSetupType=false
UsePreviousTasks=false
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
ShowTasksTreeLines=true
DisableWelcomePage=False
AppCopyright=Copyright � 2021 Ethea S.r.l. e Andrea Magni
ArchitecturesInstallIn64BitMode=x64
MinVersion=0,6.0
CloseApplications=force
UninstallDisplayIcon={app}\FEViewer.exe

[Languages]
Name: ita; MessagesFile: compiler:Languages\Italian.isl; LicenseFile: .\Licenza_ITA.rtf


[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked; Components: Viewer

[Files]
Source: "..\Bin32\FEViewer.exe"; DestDir: "{app}"; Flags: ignoreversion 32bit; Components: Viewer
Source: "..\Bin32\FExplorer32.dll"; DestDir: {app}; Flags : regserver sharedfile noregerror; Components: ShellExtensions
Source: "..\Bin32\libeay32.dll"; DestDir: {app}; Components: ShellExtensions; Flags: ignoreversion 32bit
Source: "..\Bin32\ssleay32.dll"; DestDir: {app}; Components: ShellExtensions; Flags: ignoreversion 32bit

Source: "..\Bin64\FEViewer.exe"; DestDir: "{app}"; Flags: ignoreversion 64bit; Components: Viewer
Source: "..\Bin64\FExplorer.dll"; DestDir: {app}; Flags : 64bit regserver sharedfile noregerror; Components: ShellExtensions
Source: "..\Bin64\libeay32.dll"; DestDir: {app}; Components: ShellExtensions; Flags: ignoreversion 64bit
Source: "..\Bin64\ssleay32.dll"; DestDir: {app}; Components: ShellExtensions; Flags: ignoreversion 64bit

[Icons]
Name: "{group}\FEViewer"; Filename: "{app}\FEViewer.exe"; WorkingDir: "{app}"; IconFilename: "{app}\FEViewer.exe"; Components: Viewer
Name: "{userdesktop}\FEViewer"; Filename: "{app}\FEViewer.exe"; Tasks: desktopicon; Components: Viewer

[Run]
Filename: {app}\FEViewer.exe; Description: {cm:LaunchProgram,'Visualizzatore Fattura Elettronica'}; Flags: nowait postinstall skipifsilent; Components: Viewer

[Components]
Name: Viewer; Description: Visualizzatore Fattura Elettronica; Flags: fixed; Types: custom full
Name: ShellExtensions; Description: Fattura Elettronica Explorer (integrato in Windows); Types: custom compact full

[Registry]
Root: "HKCR"; Subkey: ".xml"; ValueType: string; ValueData: "Open"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "OpenFEViewer"; ValueType: string; ValueData: "File Fattura elettronica"; Flags: uninsdeletekey
Root: "HKCR"; Subkey: "OpenFEViewer\Shell\Open\Command"; ValueType: string; ValueData: """{app}\FEViewer.exe"" ""%1"""; Flags: uninsdeletevalue
Root: "HKCR"; Subkey: "OpenFEViewer\DefaultIcon"; ValueType: string; ValueData: "{app}\FEViewer.exe,0"; Flags: uninsdeletevalue

[Code]
function InitializeSetup(): Boolean;
begin
   Result:=True;
end;

function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
var
  s : string;
begin
  s := GetUninstallString();
  //MsgBox('GetUninstallString '+s, mbInformation, MB_OK);
  Result := (s <> '');
end;

function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES', '', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      MsgBox(ExpandConstant('Una vecchia versione di "Fattura Elettronica Explorer" � gi� installata: verr� eseguita la disinstallazione.'), mbInformation, MB_OK);
      UnInstallOldVersion();
    end;
  end;
end;