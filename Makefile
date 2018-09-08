all:
	@echo NoOp

play: play.c
	clang -o $@ $< -lasound
	./play </usr/share/sounds/alsa/Front_Center.wav
