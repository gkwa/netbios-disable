disable-netbios-overtcpip : disable-netbios-overtcpip.nsi
	makensis disable-netbios-overtcpip.nsi

disable-netbios-overtcpip.exe : disable-netbios-overtcpip.nsi
	makensis disable-netbios-overtcpip.nsi

run : disable-netbios-overtcpip.exe
	cmd /c Disable-Netbios-OvertcpipName.exe

un : 
	"c:/Program Files/Disable-Netbios-OvertcpipName/Uninstall.exe"
	cd "c:/Program Files"

full : run un

clean : 
	rm Disable-Netbios-Overtcpip.exe