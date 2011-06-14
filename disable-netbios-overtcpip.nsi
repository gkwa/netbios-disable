	# http://support.microsoft.com/kb/204279
	# You can also disable NetBIOS over TCP/IP by using a DHCP server with
  # Microsoft vendor-specific option code 1, ("Disable NetBIOS over
  # TCP/IP"). Setting this option to a value of 2 disables NBT. For more
  # information about using this method, refer to the DHCP Server Help
  # file in Windows.



!include MUI2.NSH
!include nsDialogs.nsh

Name ${name}
OutFile ${outfile}

XPStyle on
ShowInstDetails show
ShowUninstDetails show
RequestExecutionLevel admin
Caption "Streambox $(^Name) Installer"

;--------------------------------
; docs
# http://nsis.sourceforge.net/Docs 
# http://nsis.sourceforge.net/Macro_vs_Function 
# http://nsis.sourceforge.net/Adding_custom_installer_pages 
# http://nsis.sourceforge.net/ConfigWrite 
# loops  
# http://nsis.sourceforge.net/Docs/Chapter2.html#\2.3.6 

;--------------------------------
Var Dialog 
Var sysdrive

;--------------------------------
;Interface Configuration

!define MUI_WELCOMEPAGE_TITLE "Welcome to the Streambox setup wizard."
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT 
!define MUI_HEADERIMAGE_BITMAP nsis-streambox2\Graphics\sblogo.bmp
!define MUI_WELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_UNWELCOMEFINISHPAGE_BITMAP nsis-streambox2\Graphics\sbside.bmp
!define MUI_ABORTWARNING
!define MUI_ICON nsis-streambox2\Icons\Streambox_128.ico

UninstallIcon nsis-streambox2\Icons\Streambox_128.ico
UninstallText "This will uninstall template"

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
#!insertmacro MUI_PAGE_LICENSE nsis-streambox2\Docs\License.txt
!insertmacro NSD_FUNCTION_INIFILE
# !insertmacro MUI_PAGE_COMPONENTS
Page custom nsDialogsPage nsDialogsPageLeave
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
!insertmacro MUI_LANGUAGE "English"


;--------------------------------
; Functions

Function .onInit
	StrCpy $sysdrive $WINDIR 1

FunctionEnd

Function .onInstSuccess

FunctionEnd


Function nsDialogsPage
  nsDialogs::Create 1018
  Pop $Dialog

  ${If} $Dialog == error
    Abort
  ${EndIf}

  nsDialogs::Show

FunctionEnd


Function nsDialogsPageLeave

FunctionEnd


Function UN.onInit

FunctionEnd



UninstallIcon nsis-streambox2\Icons\Streambox_128.ico

Section Uninstall

	rmdir /r "$PROGRAMFILES\template"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxtemplate"
SectionEnd


Section "Section Name 1" Section1

	StrCpy $0 0
	loop:
	  EnumRegKey $1 HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces $0
	  StrCmp $1 "" done
	  IntOp $0 $0 + 1
#		DetailPrint "$$1: $1"


#		DetailPrint "$$2: $2"

	# http://support.microsoft.com/kb/204279
		# set NetbiosOptions = 2 in order to disable netbios over tcpip

		# if NetbiosOptions value exists, then set it to 2 in order to disable it
		# if NetbiosOptions value doesn't exists, then do nothing...go to next reg value
		ReadRegDWORD $2 HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\$1 NetbiosOptions
	  StrCmp $2 "" +2 0
		WriteRegDWORD HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\$1 NetbiosOptions 2
		goto loop
	done:


	# DetailPrint "hello world"
  # CreateDirectory	"$PROGRAMFILES\template"

	# ;Store uninstall info in add/remove programs
	# WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxtemplate" "DisplayName" "Streambox(R) template"
	# WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxtemplate" "UninstallString" $PROGRAMFILES\template\Uninstall.exe
	# WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxtemplate" "DisplayIcon" $PROGRAMFILES\template\Streambox_128.ico
	# WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Streamboxtemplate" "NoModify" 1

	# ;Create Uninstaller
	# File /oname=$PROGRAMFILES\template\Streambox_128.ico nsis-streambox2\Icons\Streambox_128.ico
	# # WriteUninstaller $PROGRAMFILES\template\Uninstall.exe
SectionEnd

Section "Section Name 2" Section2

SectionEnd


;--------------------------------
; this must remain after the Section definitions 

LangString DESC_Section1 ${LANG_ENGLISH} "Description of section 1."
LangString DESC_Section2 ${LANG_ENGLISH} "Description of section 2."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
  !insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
