Unicode true
!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"
!include "WinVer.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"
${UnStrStr}
Name "Madang"
OutFile "${OUTPUT}"
InstallDir "$LOCALAPPDATA\Programs\Madang"
InstallDirRegKey HKCU "Software\Madang\Installer" "InstallDir"
RequestExecutionLevel user
SetCompressor /SOLID lzma
BrandingText "Madang"
VIProductVersion "${VERSION}.0"
VIAddVersionKey /LANG=1033 "ProductName" "Madang"
VIAddVersionKey /LANG=1033 "FileDescription" "Madang Installer"
VIAddVersionKey /LANG=1033 "FileVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "ProductVersion" "${VERSION}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Copyright 2026 Deskland authors and Madang contributors"
!define MUI_ABORTWARNING
!define MUI_ICON "${PAYLOAD}\host\bin\Madang.ico"
!define MUI_UNICON "${PAYLOAD}\host\bin\Madang.ico"
!define MUI_FINISHPAGE_RUN "$INSTDIR\host\bin\Madang.exe"
!define MUI_FINISHPAGE_RUN_TEXT "$(LaunchApp)"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${PAYLOAD}\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "SimpChinese"
LangString LaunchApp ${LANG_SIMPCHINESE} "启动 Madang"
LangString LaunchApp ${LANG_ENGLISH} "Launch Madang"
LangString LaunchApp ${LANG_KOREAN} "Madang 실행"
LangString AppFiles ${LANG_SIMPCHINESE} "Madang（星座、初雪、沙滩和草地）"
LangString AppFiles ${LANG_ENGLISH} "Madang (Constellations, First Snow, Beach and Meadow)"
LangString AppFiles ${LANG_KOREAN} "Madang (별자리, 첫눈, 해변, 초원)"
LangString DesktopShortcut ${LANG_SIMPCHINESE} "桌面快捷方式"
LangString DesktopShortcut ${LANG_ENGLISH} "Desktop shortcut"
LangString DesktopShortcut ${LANG_KOREAN} "바탕화면 바로 가기"
LangString NeedX64 ${LANG_SIMPCHINESE} "需要 64 位 Windows 10 或更高版本。"
LangString NeedX64 ${LANG_ENGLISH} "64-bit Windows 10 or later is required."
LangString NeedX64 ${LANG_KOREAN} "64비트 Windows 10 이상이 필요합니다."
LangString CloseFailed ${LANG_SIMPCHINESE} "请退出正在运行的 Madang 后重试。"
LangString CloseFailed ${LANG_ENGLISH} "Please exit Madang and retry."
LangString CloseFailed ${LANG_KOREAN} "실행 중인 Madang을 종료한 뒤 다시 시도해 주세요."
LangString RuntimeFailed ${LANG_SIMPCHINESE} "WebView2 安装未完成。请连接网络，安装 Microsoft Edge WebView2 Runtime 后重试。"
LangString RuntimeFailed ${LANG_ENGLISH} "WebView2 setup did not complete. Connect to the internet, install Microsoft Edge WebView2 Runtime, and retry."
LangString RuntimeFailed ${LANG_KOREAN} "WebView2 설치를 마치지 못했습니다. 인터넷에 연결해 Microsoft Edge WebView2 Runtime을 설치한 뒤 다시 시도해 주세요."
LangString InstallingRuntime ${LANG_SIMPCHINESE} "正在安装 Microsoft Edge WebView2 Runtime（需要联网）..."
LangString InstallingRuntime ${LANG_ENGLISH} "Installing Microsoft Edge WebView2 Runtime (internet required)..."
LangString InstallingRuntime ${LANG_KOREAN} "Microsoft Edge WebView2 Runtime 설치 중 (인터넷 필요)..."

Function .onInit
  ${IfNot} ${RunningX64}
    MessageBox MB_ICONSTOP "$(NeedX64)"
    SetErrorLevel 1
    Abort
  ${EndIf}
  ${IfNot} ${AtLeastWin10}
    MessageBox MB_ICONSTOP "$(NeedX64)"
    SetErrorLevel 1
    Abort
  ${EndIf}
  SetShellVarContext current
  SetRegView 64
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function CheckRuntime
  StrCpy $0 ""
  SetRegView 32
  ReadRegStr $0 HKLM "Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" "pv"
  ${If} $0 == ""
    ReadRegStr $0 HKCU "Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" "pv"
  ${EndIf}
  SetRegView 64
  ${If} $0 == ""
    ReadRegStr $0 HKCU "Software\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" "pv"
  ${EndIf}
FunctionEnd

Section "$(AppFiles)" SecApp
  SectionIn RO
  Call CheckRuntime
  ${If} $0 == ""
  ${OrIf} $0 == "0.0.0.0"
    InitPluginsDir
    SetOutPath "$PLUGINSDIR"
    File /oname=MicrosoftEdgeWebview2Setup.exe "${BOOTSTRAPPER}"
    DetailPrint "$(InstallingRuntime)"
    ExecWait '"$PLUGINSDIR\MicrosoftEdgeWebview2Setup.exe" /silent /install' $1
    Call CheckRuntime
    ${If} $0 == ""
    ${OrIf} $0 == "0.0.0.0"
      MessageBox MB_ICONSTOP "$(RuntimeFailed)"
      SetErrorLevel 2
      Abort
    ${EndIf}
  ${EndIf}
  IfFileExists "$INSTDIR\host\bin\Madang.exe" 0 closed
  ExecWait '"$INSTDIR\host\bin\Madang.exe" --exit-installed' $0
  ${If} $0 != 0
    MessageBox MB_ICONSTOP "$(CloseFailed)"
    SetErrorLevel 3
    Abort
  ${EndIf}
  closed:
  !include "${FILE_LIST}"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  CreateDirectory "$SMPROGRAMS\Madang"
  CreateShortcut "$SMPROGRAMS\Madang\Madang.lnk" "$INSTDIR\host\bin\Madang.exe"
  CreateShortcut "$SMPROGRAMS\Madang\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Madang\Installer" "InstallDir" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "DisplayName" "Madang"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "Publisher" "Madang"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "InstallLocation" "$INSTDIR"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "DisplayIcon" "$INSTDIR\host\bin\Madang.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "UninstallString" '$\"$INSTDIR\Uninstall.exe$\"'
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "QuietUninstallString" '$\"$INSTDIR\Uninstall.exe$\" /S'
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "NoModify" 1
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "NoRepair" 1
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang" "EstimatedSize" $0
SectionEnd

Function un.onInit
  SetShellVarContext current
  SetRegView 64
FunctionEnd
Section "Uninstall"
  IfFileExists "$INSTDIR\host\bin\Madang.exe" 0 unclosed
  ExecWait '"$INSTDIR\host\bin\Madang.exe" --exit-installed' $0
  ${If} $0 != 0
    MessageBox MB_ICONSTOP "$(CloseFailed)"
    SetErrorLevel 3
    Abort
  ${EndIf}
  unclosed:
  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "Madang"
  ${UnStrStr} $1 $0 '$\"$INSTDIR\host\bin\Madang.exe$\"'
  ${If} $1 != ""
    DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "Madang"
  ${EndIf}
  !include "${DELETE_LIST}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"
  Delete "$SMPROGRAMS\Madang\Madang.lnk"
  Delete "$SMPROGRAMS\Madang\Uninstall.lnk"
  RMDir "$SMPROGRAMS\Madang"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Madang"
  DeleteRegKey HKCU "Software\Madang\Installer"
  DeleteRegKey /ifempty HKCU "Software\Madang"
SectionEnd
