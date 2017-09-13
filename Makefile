all:
	@echo NoOp

play: play.c
	clang -o $@ $< -lasound
