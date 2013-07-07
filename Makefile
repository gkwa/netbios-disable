name=disable-netbios-overtcpip

MAKEFLAGS += --warn-undefined-variables

GIT = git
MAKENSIS = makensis
RM = rm -f
UNIX2DOS = unix2dos

ifneq ($(findstring $(MAKEFLAGS),w),w)
	PRINT_DIR = --no-print-directory
endif

MAKENSIS_SW  =
QUIET_MAKENSIS =
QUIET_GEN =
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_MAKENSIS = @echo '   ' MAKENSIS $@;
	QUIET_GEN      = @echo '   ' GEN $@;
	export V

	MAKENSIS_SW += /V2
endif
endif

installer=$(name).exe

MAKENSIS_SW += /Doutfile=$(installer)
MAKENSIS_SW += /Dname="$(name)"

$(installer): disable-netbios-overtcpip.nsi
	$(QUIET_MAKENSIS)$(MAKENSIS) $(MAKENSIS_SW) $<


t1: test_disableNetbios
test_disableNetbios: $(installer)
	cmd /c $(installer)
	$(check)

t2: test_disableNetbios1
test_disableNetbios1: $(installer)
	cmd /c $(installer) -disable 1
	$(check)

t3: test_enableNetbios
test_enableNetbios: $(installer)
	cmd /c $(installer) -enable 1
	$(check)

clean: 
	$(RM) $(installer)

check: $(installer)
	$(check)

check = \
	./regjump \
		'HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces'

.PHONY: test_enableNetbios
.PHONY: clean
.PHONY: check
.PHONY: test_disableNetbios
.PHONY: test_disableNetbios1
