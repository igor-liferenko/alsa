all:
	@echo NoOp

eps:
	@make --no-print-directory `grep -o '^\S*\.eps' Makefile`

.PHONY: $(wildcard *.eps)

01.eps: 01.png
	@convert $< $@
02.eps: 02.png
	@convert $< $@
03.eps: 03.png
	@convert $< $@
04.eps: 04.png
	@convert $< $@
05.eps: 05.png
	@convert $< $@
06.eps: 06.png
	@convert $< $@
