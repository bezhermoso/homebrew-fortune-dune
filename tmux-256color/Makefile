install:
	$(ncurses_path)/bin/infocmp -x tmux-256color | \
		sed -E 's/pairs#(0x10000|65536)/pairs#32767/' | \
		tic -x -o terminfo -


