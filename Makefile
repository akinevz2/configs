# Makefile for installing required packages

# List of packages to install
# PACKAGES := herbstluftwm neovim zsh rofi dunst polybar 

# List of supported packages
PACKAGES := zsh
INSTALL_PACKAGES := stow zsh
UNINSTALL_PACKAGES := stow zsh

all:
	@echo "This is a warning"
	@echo "This package contains unverified code"
	@echo "Do not install, unless you're ready to stop using bash"

# all: install stow

# Install packages using apt
install:
	sudo apt update
	sudo apt install -y $(INSTALL_PACKAGES) build-essential
	@echo "Installed $(INSTALL_PACKAGES)."

uninstall:
	sudo apt remove -y $(UNINSTALL_PACKAGES)
	@echo "Removed $(UNINSTALL_PACKAGES)."

# Stow packages
stow-%:
	@if echo $(PACKAGES) | grep -q $*; then \
		echo "Stowing $*."; \
		stow -v -t $(HOME) $*; \
	else \
		echo "Error: $* is not in the list of packages."; \
		exit 1; \
	fi

stow:
	@for package in $(PACKAGES); do \
		echo "Stowing $$package."; \
		$(MAKE) stow-$$package 1>/dev/null; \
	done
	@echo "Stowing complete."

# Adopt packages
adopt-%:
	@if echo $(PACKAGES) | grep -q $*; then \
		stow --adopt -v -t $(HOME) $*; \
		echo "Adopting $* complete."; \
		stow -D -v -t $(HOME) $*; \
	else \
		echo "Error: $* is not in the list of packages."; \
		exit 1; \
	fi

adopt:
	@for package in $(PACKAGES); do \
		echo "Adopting $$package."; \
		$(MAKE) adopt-$$package 1>/dev/null; \
	done
	@echo "Adoption complete."

# Unstow packages
unstow-zsh:
	@if [ -f $(HOME)/.local/bin/clean-zsh ]; then \
		echo "Running zsh cleanup script."; \
		$(HOME)/.local/bin/clean-zsh; \
	fi
	stow -D -v -t $(HOME) zsh
	stow -D -v -t $(HOME) zsh-scripts
	@echo "Unstowing zsh complete."

unstow-%:
	@if echo $(PACKAGES) | grep -q $*; then \
		stow -D -v -t $(HOME) $*; \
		echo "Unstowing $* complete."; \
	else \
		echo "Error: $* is not in the list of packages."; \
		exit 1; \
	fi

unstow:
	@for package in $(PACKAGES); do \
		echo "Unstowing $$package."; \
		$(MAKE) unstow-$$package 1>/dev/null; \
	done
	@echo "Unstowing complete."

clean: unstow uninstall

.PHONY: all install uninstall stow unstow clean

