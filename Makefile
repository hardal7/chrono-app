.PHONY: check-l10n l10n

check-l10n:
	@echo "Checking for hardcoded UI strings..."
	@grep -R -n -E 'Text\([[:space:]]*["'\'']|text:[[:space:]]*["'\'']' lib/ || true

l10n:
	flutter gen-l10n
