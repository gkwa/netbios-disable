name=disable-netbios-overtcpip
outfile=$(name).exe

$(outfile): $(name).nsi
	makensis \
		/Doutfile=$(outfile) \
		/Dname=$(name) \
		$<

test: $(outfile)
	cmd /c $(outfile)
.PHONY: test

clean: 
	rm -f \
		$(outfile)
.PHONY: clean
