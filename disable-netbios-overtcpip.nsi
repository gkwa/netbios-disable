!include MUI2.NSH
!include FileFunc.nsh

Name ${name}
OutFile ${outfile}

XPStyle on
ShowInstDetails show
RequestExecutionLevel admin
AutoCloseWindow true
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
Var netbiosOnOff

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

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES # this macro is the macro that invokes the Sections
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Functions

Function .onInit

	push off
	pop $netbiosOnOff

	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '-enable' $1
	${IfNot} ${Errors}
		push on
		pop $netbiosOnOff
	${EndIf}

	${GetParameters} $0
	ClearErrors
	${GetOptions} $0 '-disable' $1
	${IfNot} ${Errors}
		push off
		pop $netbiosOnOff
	${EndIf}

FunctionEnd

Function .onInstSuccess
FunctionEnd

Section SetNetbios section_SetNetbios

	# translate on/off to 1 or 2 according to http://technet.microsoft.com/en-us/library/cc749124%28WS.10%29.aspx
  ${If} "on" == $netbiosOnOff
		push 1
  ${Else}
		push 2
  ${EndIf}
	pop $netbiosOnOff

	StrCpy $0 0
	loop:
	  EnumRegKey $1 HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces $0
	  StrCmp $1 "" done
	  IntOp $0 $0 + 1
#		DetailPrint "$$1: $1"
#		DetailPrint "$$2: $2"

		# http://support.microsoft.com/kb/204279
		# http://technet.microsoft.com/en-us/library/cc749124%28WS.10%29.aspx
		# set NetbiosOptions = 2 in order to disable netbios over tcpip
		# if NetbiosOptions value exists, then set it to 2 in order to disable it
		# if NetbiosOptions value doesn't exists, then do nothing...go to next reg value
		ReadRegDWORD $2 HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\$1 NetbiosOptions
		WriteRegDWORD HKLM SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\$1 NetbiosOptions $netbiosOnOff
		goto loop
	done:
SectionEnd

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
