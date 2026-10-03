; Nova — instalador con presentación animada y opciones. Se compila en GitHub Actions.
Unicode true
!ifndef VERSION
  !define VERSION "0.1.0"
!endif
!define EXE "floorp.exe"
!define ARGS '-profile "$APPDATA\Nova\Profile"'

!include MUI2.nsh
!include nsDialogs.nsh
!include LogicLib.nsh

Name "Nova ${VERSION}"
OutFile "..\dist\Nova-Setup-${VERSION}.exe"
InstallDir "$LOCALAPPDATA\Programs\Nova"
RequestExecutionLevel user
SetCompressor /SOLID lzma
BrandingText "Nova ${VERSION}"

!define MUI_ICON "..\assets\icon.ico"
!define MUI_UNICON "..\assets\icon.ico"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TITLE "Nova está listo"
!define MUI_FINISHPAGE_TEXT "Nova se instaló correctamente. Tus datos se guardan en tu carpeta de usuario y se conservan al actualizar."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Abrir Nova ahora"
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchNova

Var Dlg
Var Img
Var ImgHandle
Var Idx
Var ChkDesk
Var ChkMenu
Var ChkDef
Var DoDesk
Var DoMenu
Var DoDef

Function SlideTick
  IntOp $Idx $Idx + 1
  ${If} $Idx > 4
    StrCpy $Idx 1
  ${EndIf}
  ${NSD_SetStretchedImage} $Img "$PLUGINSDIR\s$Idx.bmp" $ImgHandle
FunctionEnd

Function WelcomeShow
  !insertmacro MUI_HEADER_TEXT "Bienvenido a Nova" "Un navegador calmado, rápido y tuyo."
  InitPluginsDir
  File "/oname=$PLUGINSDIR\s1.bmp" "slide1.bmp"
  File "/oname=$PLUGINSDIR\s2.bmp" "slide2.bmp"
  File "/oname=$PLUGINSDIR\s3.bmp" "slide3.bmp"
  File "/oname=$PLUGINSDIR\s4.bmp" "slide4.bmp"
  nsDialogs::Create 1018
  Pop $Dlg
  ${If} $Dlg == error
    Abort
  ${EndIf}
  StrCpy $Idx 1
  ${NSD_CreateBitmap} 0 0 100% 120u ""
  Pop $Img
  ${NSD_SetStretchedImage} $Img "$PLUGINSDIR\s1.bmp" $ImgHandle
  ${NSD_CreateLabel} 0 128u 100% 24u "Pulsa Siguiente para elegir dónde instalar Nova. Si ya tienes Nova, se actualiza sin perder tus datos."
  Pop $0
  ${NSD_CreateTimer} SlideTick 2600
  nsDialogs::Show
  ${NSD_KillTimer} SlideTick
FunctionEnd

Function OptShow
  !insertmacro MUI_HEADER_TEXT "Opciones" "Elige cómo quieres integrar Nova en Windows."
  nsDialogs::Create 1018
  Pop $Dlg
  ${NSD_CreateCheckbox} 0 10u 100% 12u "Crear acceso directo en el escritorio"
  Pop $ChkDesk
  ${NSD_Check} $ChkDesk
  ${NSD_CreateCheckbox} 0 28u 100% 12u "Crear acceso directo en el menú Inicio"
  Pop $ChkMenu
  ${NSD_Check} $ChkMenu
  ${NSD_CreateCheckbox} 0 46u 100% 12u "Abrir Ajustes de Windows para elegir Nova como navegador predeterminado"
  Pop $ChkDef
  nsDialogs::Show
FunctionEnd

Function OptLeave
  ${NSD_GetState} $ChkDesk $DoDesk
  ${NSD_GetState} $ChkMenu $DoMenu
  ${NSD_GetState} $ChkDef $DoDef
FunctionEnd

Function LaunchNova
  Exec '"$INSTDIR\${EXE}" ${ARGS}'
  ${If} $DoDef == ${BST_CHECKED}
    ExecShell "open" "ms-settings:defaultapps"
  ${EndIf}
FunctionEnd

Page custom WelcomeShow
!insertmacro MUI_PAGE_DIRECTORY
Page custom OptShow OptLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Spanish"

Section "Nova"
  SetOutPath "$INSTDIR"
  File /r "..\stage\core\*.*"
  File "/oname=$INSTDIR\nova.ico" "..\assets\icon.ico"
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ${If} $DoDesk == ${BST_CHECKED}
    CreateShortcut "$DESKTOP\Nova.lnk" "$INSTDIR\${EXE}" '${ARGS}' "$INSTDIR\nova.ico" 0
  ${EndIf}
  ${If} $DoMenu == ${BST_CHECKED}
    CreateShortcut "$SMPROGRAMS\Nova.lnk" "$INSTDIR\${EXE}" '${ARGS}' "$INSTDIR\nova.ico" 0
  ${EndIf}

  ; Desinstalador en "Aplicaciones instaladas"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova" "DisplayName" "Nova"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova" "DisplayVersion" "${VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova" "Publisher" "Nova"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova" "DisplayIcon" "$INSTDIR\nova.ico"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova" "UninstallString" '"$INSTDIR\Uninstall.exe"'

  ; Registro como navegador (aparece en Aplicaciones predeterminadas; NO cambia el predeterminado solo)
  WriteRegStr HKCU "Software\Classes\NovaURL" "" "Nova URL"
  WriteRegStr HKCU "Software\Classes\NovaURL" "URL Protocol" ""
  WriteRegStr HKCU "Software\Classes\NovaURL\DefaultIcon" "" "$INSTDIR\nova.ico"
  WriteRegStr HKCU "Software\Classes\NovaURL\shell\open\command" "" '"$INSTDIR\${EXE}" ${ARGS} -osint -url "%1"'
  WriteRegStr HKCU "Software\Classes\NovaHTML" "" "Nova HTML Document"
  WriteRegStr HKCU "Software\Classes\NovaHTML\DefaultIcon" "" "$INSTDIR\nova.ico"
  WriteRegStr HKCU "Software\Classes\NovaHTML\shell\open\command" "" '"$INSTDIR\${EXE}" ${ARGS} -osint -url "%1"'
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova" "" "Nova"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\DefaultIcon" "" "$INSTDIR\nova.ico"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\shell\open\command" "" '"$INSTDIR\${EXE}" ${ARGS}'
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities" "ApplicationName" "Nova"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities" "ApplicationDescription" "Navegador Nova"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities" "ApplicationIcon" "$INSTDIR\nova.ico,0"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities\URLAssociations" "http" "NovaURL"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities\URLAssociations" "https" "NovaURL"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities\FileAssociations" ".htm" "NovaHTML"
  WriteRegStr HKCU "Software\Clients\StartMenuInternet\Nova\Capabilities\FileAssociations" ".html" "NovaHTML"
  WriteRegStr HKCU "Software\RegisteredApplications" "Nova" "Software\Clients\StartMenuInternet\Nova\Capabilities"
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\Nova.lnk"
  Delete "$SMPROGRAMS\Nova.lnk"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Nova"
  DeleteRegKey HKCU "Software\Classes\NovaURL"
  DeleteRegKey HKCU "Software\Classes\NovaHTML"
  DeleteRegKey HKCU "Software\Clients\StartMenuInternet\Nova"
  DeleteRegValue HKCU "Software\RegisteredApplications" "Nova"
  RMDir /r "$INSTDIR"
SectionEnd
