eps:
	@make --no-print-directory `grep -o '^\S*\.eps' Makefile`

.PHONY: $(wildcard *.eps)

setup-tarif.eps:
	@$(inkscape) setup-tarif.svg

inkscape=inkscape -E $@ --export-text-to-path
