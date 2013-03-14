name=disable-netbios-overtcpip
installer=$(name).exe

$(installer): $(name).nsi
	@makensis \
		/V2 \
		/Doutfile=$(installer) \
		/Dname=$(name) \
		$<

t1: test_disableNetbios
test_disableNetbios: $(installer)
	cmd /c $(installer)
	$(check)
.PHONY: test_disableNetbios

t2: test_disableNetbios1
test_disableNetbios1: $(installer)
	cmd /c $(installer) -disable 1
	$(check)
.PHONY: test_disableNetbios1

t3: test_enableNetbios
test_enableNetbios: $(installer)
	cmd /c $(installer) -enable 1
	$(check)
.PHONY: test_enableNetbios

clean: 
	@rm -f \
		$(installer)
.PHONY: clean

check: $(installer)
	$(check)
.PHONY: check

check = \
	./regjump \
		'HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces'

