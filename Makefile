OS = $(shell uname)

seed:
	./seed.sh

setup: seed
	stow -t $(HOME) zsh
	stow -t $(HOME) nvim
	stow -t $(HOME)/bin bin
	@if [ "$(OS)" = "Darwin" ]; then \
		echo "Setting up MacOS specific dotfiles"; \
		stow -t $(HOME) karabiner; \
		stow -t $(HOME) hammerspoon; \
	fi
