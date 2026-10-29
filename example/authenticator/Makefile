REPO := ../..
PYTHON ?= python3
.PHONY: build extract test verify docs benchmark report readable
build extract test verify docs benchmark report readable:
	cd $(REPO) && $(PYTHON) scripts/project.py $@ --example authenticator
cli ui frontends frontend-test docs-check:
	$(PYTHON) scripts/project.py $@
