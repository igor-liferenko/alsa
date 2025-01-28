eps:
	@make --no-print-directory `grep -o '^\S*\.eps' Makefile`

.PHONY: $(wildcard *.eps)

setup-tarif.eps:
	@$(inkscape) setup-tarif.svg

inkscape=inkscape --export-type=eps --export-ps-level=2 -T -o $@ 2>/dev/null
