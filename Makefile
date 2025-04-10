OS = $(shell uname)

seed:
	./seed.sh

setup: seed
	stow -t $(HOME) zsh
	stow -t $(HOME) nvim
	stow -t $(HOME)/bin bin
	stow -t $(HOME) tmux
	stow -t $(HOME) alacritty
	stow -t $(HOME) ghostty
	stow -t $(HOME) wezterm
	@if [ "$(OS)" = "Darwin" ]; then \
		echo "Setting up MacOS specific dotfiles"; \
		stow -t $(HOME) karabiner; \
		stow -t $(HOME) hammerspoon; \
	fi
