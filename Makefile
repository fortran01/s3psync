# https://github.com/httpie/cli/blob/master/Makefile

# .PHONY: build

PROJECT_NAME=s3psync
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VERSION=$(shell grep __version__ $(PROJECT_NAME)/__init__.py)
H1="\n\n\033[0;32m\#\#\# "
H1END=" \#\#\# \033[0m\n"

# Only used to create our venv.
SYSTEM_PYTHON=python3

VENV_ROOT=venv
VENV_BIN=$(VENV_ROOT)/bin
VENV_PIP=$(VENV_BIN)/pip3
VENV_PYTHON=$(VENV_BIN)/python


export PATH := $(VENV_BIN):$(PATH)



default: list-tasks

###############################################################################
# Default task to get a list of tasks when `make' is run without args.
# <https://stackoverflow.com/questions/4219255>
###############################################################################

list-tasks:
	@echo Available tasks:
	@echo ----------------
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo

###############################################################################
# Installation
###############################################################################

all: uninstall-$(PROJECT_NAME) install test

install: venv install-reqs

install-reqs:
	@echo $(H1)Updating package tools$(H1END)
	$(VENV_PIP) install --upgrade pip wheel build

	@echo $(H1)Installing dev requirements$(H1END)
	$(VENV_PIP) install --upgrade '.[dev]' '.[test]'

	@echo $(H1)Installing madb$(H1END)
	$(VENV_PIP) install --upgrade --editable .

	@echo

clean:
	@echo $(H1)Cleaning up$(H1END)
	rm -rf $(VENV_ROOT)
	# Remove symlink for virtualenvwrapper, if we’ve created one.
	[ -n "$(WORKON_HOME)" -a -L "$(WORKON_HOME)/$(PROJECT_NAME)" -a -f "$(WORKON_HOME)/$(PROJECT_NAME)" ] && rm $(WORKON_HOME)/$(PROJECT_NAME) || true
	rm -rf *.egg dist build .coverage .cache .pytest_cache $(PROJECT_NAME).egg-info
	find . -name '__pycache__' -delete -o -name '*.pyc' -delete
	@echo
	
venv:
	@echo $(H1)Creating a Python environment $(VENV_ROOT) $(H1END)

	$(SYSTEM_PYTHON) -m venv --prompt $(PROJECT_NAME) $(VENV_ROOT)

	@echo
	@echo done.
	@echo
	@echo To active it manually, run:
	@echo
	@echo "    source $(VENV_BIN)/activate"
	@echo
	@echo '(learn more: https://docs.python.org/3/library/venv.html)'
	@echo
	@if [ -n "$(WORKON_HOME)" ]; then \
		echo $(ROOT_DIR) >  $(VENV_ROOT)/.project; \
		if [ ! -d $(WORKON_HOME)/$(PROJECT_NAME) -a ! -L $(WORKON_HOME)/$(PROJECT_NAME) ]; then \
			ln -s $(ROOT_DIR)/$(VENV_ROOT) $(WORKON_HOME)/$(PROJECT_NAME) ; \
			echo ''; \
			echo 'Since you use virtualenvwrapper, we created a symlink'; \
			echo 'so you can also use "workon $(PROJECT_NAME)" to activate the venv.'; \
			echo ''; \
		fi; \
	fi

###############################################################################
# Placeholder - Testing
###############################################################################

test:
	@echo $(H1)Running tests$(H1END)
	@echo Placeholder for test process
	@echo


###############################################################################
# Placeholder - Publishing to PyPi
###############################################################################

build:
	@echo $(H1)Building for PyPi$(H1END)
	@echo Placeholder for build process
	@echo

publish:
	@echo $(H1)Publishing to PyPi$(H1END)
	@echo Placeholder for publish process
	@echo

publish-no-test:
	@echo $(H1)Publishing to PyPi without testing$(H1END)
	@echo Placeholder for publish process
	@echo

###############################################################################
# Uninstalling
###############################################################################

uninstall-$(PROJECT_NAME):
	@echo $(H1)Uninstalling $(PROJECT_NAME)$(H1END)
	- $(VENV_PIP) uninstall --yes $(PROJECT_NAME) &2>/dev/null

	@echo "Verifying…"
	cd .. && ! $(VENV_PYTHON) -m $(PROJECT_NAME) --version &2>/dev/null

	@echo "Done"
	@echo

###############################################################################
# Placeholder - Homebrew
###############################################################################

brew-deps:
	@echo $(H1)Installing Homebrew dependencies$(H1END)
	@echo Placeholder for Homebrew dependencies
	@echo

brew-test:
	@echo $(H1)Running Homebrew tests$(H1END)
	@echo Placeholder for Homebrew tests
	@echo


###############################################################################
# Placeholder - Generated content
###############################################################################

content: man installation-docs

man: 
	@echo $(H1)Generating man pages$(H1END)
	@echo Placeholder for man pages generation
	@echo

installation-docs:
	@echo $(H1)Generating installation docs$(H1END)
	@echo Placeholder for installation docs generation
	@echo
