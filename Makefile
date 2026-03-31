.PHONY: help install-hooks verify

help:
	@echo "Targets:"
	@echo "  make install-hooks  Configure this clone to use repo-managed git hooks"
	@echo "  make verify         Run fast repo-wide consistency checks"

install-hooks:
	git config core.hooksPath githooks

verify:
	./verify_repo.sh
