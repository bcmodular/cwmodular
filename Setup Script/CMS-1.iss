; -- 64BitTwoArch.iss --
; Demonstrates how to install a program built for two different
; architectures (x86 and x64) using a single installer.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!
#define AppName "CMS-1"
#define RegSubKey "Software\CWModular\CMS-1"

[Setup]
AppName={#AppName}
AppVersion=0.1.0
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
UninstallDisplayIcon={app}\{#AppName}.ico
AppPublisher=CWModular
AppPublisherURL=http://cwmodular.org/
AppCopyright=Copyright (C) 2018 CWModular
AppContact=support@cwmodular.org
AppSupportURL=http://bcmodular.co.uk/forum/
AppUpdatesURL=http://cwmodular.org/
Compression=lzma2
SolidCompression=yes
LicenseFile=cms-1-license.txt
InfoAfterFile=cms-1-infoafter.rtf
OutputBaseFilename=CMS-1
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
ArchitecturesInstallIn64BitMode=x64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).

;[Types]
;Name: "typical"; Description: "Typical installation"
;Name: "full"; Description: "Full installation"
;Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Files]
; Install MyProg-x64.exe if running in 64-bit mode (x64; see above),
; MyProg.exe otherwise.
; Place all x64 files here
;Source: "..\Plugins\Windows\VST2\64bit\*"; DestDir: "{code:GetVST2Dir}\{#AppName}"; Flags: ignoreversion; Check: Is64BitInstallMode; Components:VSTPlugin\64VST2
;Source: "..\Plugins\Windows\VST3\64bit\*"; DestDir: "{cf}\VST3\{#AppName}"; Flags: ignoreversion; Check: Is64BitInstallMode; Components:VSTPlugin\64VST3
; Place all x86 files here, first one should be marked 'solidbreak'
; Place all common files here, first one should be marked 'solidbreak'
;Source: "..\Scope DLL\*"; DestDir: "{code:GetScopeDir}\App\Dll"; Flags: ignoreversion solidbreak; Components: ScopeDLL
;Source: "..\CMS-1\ScopeDevice\CMS-1.dev"; DestDir: "{code:GetDeviceDir}"; Flags: ignoreversion; Components: ScopeDevice
;Source: "..\CMS-1\ScopeDevice\CMS-1.pre"; DestDir: "{code:GetPresetsDir}"; Flags: ignoreversion; Components: ScopePresets
;Source: "..\Plugins\Windows\VST2\32bit\*"; DestDir: "{code:GetVST2Dir}\{#AppName}"; Flags: ignoreversion; Components:VSTPlugin\32VST2
;Source: "..\Plugins\Windows\VST3\32bit\*"; DestDir: "{cf32}\{#AppName}"; Flags: ignoreversion; Components:VSTPlugin\32VST3
;Source: "..\MS\VC_redist.x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall
;Source: "..\MS\VC_redist.x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall
Source: "..\Plugins\Windows\VST2\64bit\*"; DestDir: "{code:GetVST2Dir}\{#AppName}"; Flags: ignoreversion; Check: Is64BitInstallMode;
Source: "..\Plugins\Windows\VST3\64bit\*"; DestDir: "{cf}\VST3\{#AppName}"; Flags: ignoreversion; Check: Is64BitInstallMode;
; Place all x86 files here, first one should be marked 'solidbreak'
; Place all common files here, first one should be marked 'solidbreak'
Source: "..\Scope DLL\*"; DestDir: "{code:GetScopeDir}\App\Dll"; Flags: ignoreversion solidbreak;
Source: "..\CMS-1\ScopeDevice\CMS-1.dev"; DestDir: "{code:GetDeviceDir}"; Flags: ignoreversion;
Source: "..\CMS-1\ScopeDevice\CMS-1.pre"; DestDir: "{code:GetPresetsDir}"; Flags: ignoreversion uninsneveruninstall confirmoverwrite;
Source: "..\Plugins\Windows\VST2\32bit\*"; DestDir: "{code:GetVST2Dir}\{#AppName}"; Flags: ignoreversion;
Source: "..\Plugins\Windows\VST3\32bit\*"; DestDir: "{cf32}\{#AppName}"; Flags: ignoreversion;
Source: "..\MS\VC_redist.x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall
Source: "..\MS\VC_redist.x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall

[Icons]
Name: "{group}\Uninstall {#AppName}"; Filename: "{uninstallexe}"

;[Components]
;Name: "ScopeDLL"; Description: "CMS-1 ScopeSync Module"; Types: full typical
;Name: "ScopeDevice"; Description: "Scope Device"; Types: full typical
;Name: "ScopePresets"; Description: "Scope Presets"; Types: full typical
;Name: "VSTPlugin"; Description: "VST Plugins"; Types: full typical compact
;Name: "VSTPlugin\32VST2"; Description: "32-bit VST2 Plugin"; Types: full typical compact
;Name: "VSTPlugin\64VST2"; Description: "64-bit VST2 Plugin"; Types: full typical compact; Check: Is64BitInstallMode
;Name: "VSTPlugin\32VST3"; Description: "32-bit VST3 Plugin (Experimental)"
;Name: "VSTPlugin\64VST3"; Description: "64-bit VST3 Plugin (Experimental)"; Check: Is64BitInstallMode

[Run]
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /passive /norestart"; Check: Is64BitInstallMode; StatusMsg: Installing 2017 RunTime...
Filename: "{tmp}\VC_redist.x86.exe"; Parameters: "/install /passive /norestart"; Check: "not Is64BitInstallMode"; StatusMsg: Installing 2017 RunTime...

[Registry]
Root: HKCU; Subkey: "Software\CWModular\CMS1"; ValueType: string; ValueName: "InstallLocation"; ValueData: "{app}"

[Code]
// global vars
var
  ScopeDirPage1: TInputDirWizardPage;
  ScopeDirPage1ID: Integer;
  AdditionalDirPage1: TInputDirWizardPage;
  AdditionalDirPage1ID: Integer;

function GetScopeDir(Param: String): String;
var
  ScopeDir: String;
begin
  ScopeDir := ScopeDirPage1.Values[0];
  RegWriteStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'ScopeDir', ScopeDir);
  { Return the selected ScopeDir }
  Result := ScopeDir;
end;

function GetDeviceDir(Param: String): String;
var
  DeviceDir: String;
begin
  DeviceDir := ScopeDirPage1.Values[1];
  RegWriteStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'DeviceDir', DeviceDir);
  { Return the selected DeviceDir }
  Result := DeviceDir;
end;

function GetPresetsDir(Param: String): String;
var
  PresetsDir: String;
begin
  PresetsDir := ScopeDirPage1.Values[2];
  RegWriteStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'PresetsDir', PresetsDir);
  { Return the selected PresetsDir }
  Result := PresetsDir;
end;

function GetVST2Dir(Param: String): String;
var
  VST2Dir: String;
begin
  VST2Dir := AdditionalDirPage1.Values[0];
  RegWriteStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'VST2Dir', VST2Dir);
  { Return the selected VST2Dir }
  Result := VST2Dir;
end;

procedure InitializeWizard;
var
  VST2Dir: String;
  ScopeDir: String;
  DeviceDir: String;
  PresetsDir: String;
  VST3Text: String;
begin
  if not(RegQueryStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'VST2Dir', VST2Dir)) then
  begin
    VST2Dir := ExpandConstant('{sd}\VST');
  end;  

  if not(RegQueryStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'ScopeDir', ScopeDir)) then
  begin
    ScopeDir := ExpandConstant('{pf}\Scope PCI');
  end; 

  if not(RegQueryStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'DeviceDir', DeviceDir)) then
  begin
    DeviceDir := ExpandConstant('{pf}\Scope PCI\Devices\ScopeSync\CWModular');
  end; 

  if not(RegQueryStringValue(HKEY_CURRENT_USER, '{#RegSubKey}', 'PresetsDir', PresetsDir)) then
  begin
    PresetsDir := ExpandConstant('{pf}\Scope PCI\Presets');
  end; 

  ScopeDirPage1 := CreateInputDirPage(
    wpSelectComponents,
    'Select Scope Directories',
    'Where should Scope files be installed?',
    '',
    False,
    '{#AppName}'
  );
  ScopeDirPage1.Add('Scope Installation Directory');
  ScopeDirPage1.Values[0] := ScopeDir;

  ScopeDirPage1.Add('Scope Device Directory');
  ScopeDirPage1.Values[1] := DeviceDir;  

  ScopeDirPage1.Add('Scope Presets Directory');
  ScopeDirPage1.Values[2] := PresetsDir;  

  ScopeDirPage1ID := ScopeDirPage1.ID;
  
  VST3Text := 'N.B. VST3 files will be installed in the standard locations, e.g. ' + ExpandConstant('{cf}\VST3\');
  
  AdditionalDirPage1 := CreateInputDirPage(
    ScopeDirPage1ID,
    'Select VST2 Directory',
    'Where should VST2 files be installed?',
    VST3Text,
    False,
    '{#AppName}'
  );
  AdditionalDirPage1.Add('VST2 Plugin Directory');
  AdditionalDirPage1ID := AdditionalDirPage1.ID;
  AdditionalDirPage1.Values[0] := VST2Dir;

end;

//function ShouldSkipPage(PageID: Integer): Boolean;
//begin
  // initialize result to not skip any page (not necessary, but safer)
//  Result := False;
  // if the page that is asked to be skipped is your custom page, then...
//  if PageID = ScopeDirPage1ID then
//    Result := not IsComponentSelected('ScopeDLL')
//  else if PageID = ScopeDirPage2ID then
//    Result := not IsComponentSelected('BCMod')
//  else if PageID = AdditionalDirPage1ID then
//    Result := not (IsComponentSelected('VSTPlugin\32VST2') or IsComponentSelected('VSTPlugin\64VST2'));
//end;

procedure DecodeVersion (verstr: String; var verint: array of Integer);
var
  i,p: Integer; s: string;
begin
  // initialize array
  verint := [0,0,0,0];
  i := 0;
  while ((Length(verstr) > 0) and (i < 4)) do
  begin
    p := pos ('.', verstr);
    if p > 0 then
    begin
      if p = 1 then s:= '0' else s:= Copy (verstr, 1, p - 1);
      verint[i] := StrToInt(s);
      i := i + 1;
      verstr := Copy (verstr, p+1, Length(verstr));
    end
    else
    begin
      verint[i] := StrToInt (verstr);
      verstr := '';
    end;
  end;

end;

function CompareVersion (ver1, ver2: String) : Integer;
var
  verint1, verint2: array of Integer;
  i: integer;
begin

  SetArrayLength (verint1, 4);
  DecodeVersion (ver1, verint1);

  SetArrayLength (verint2, 4);
  DecodeVersion (ver2, verint2);

  Result := 0; i := 0;
  while ((Result = 0) and ( i < 4 )) do
  begin
    if verint1[i] > verint2[i] then
      Result := 1
    else
      if verint1[i] < verint2[i] then
        Result := -1
      else
        Result := 0;
    i := i + 1;
  end;

end;
