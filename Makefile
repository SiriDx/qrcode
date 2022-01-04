test:
	../.github/scripts/flutter-analyze-test --min-coverage 78

test-skip-coverage:
	../.github/scripts/flutter-analyze-test --skip-coverage

test-only-changes:
	../.github/scripts/flutter-analyze-test-changes

clean:
	flutter clean && rm -rf coverage

.PHONY: test test-skip-coverage dist-ios dist-android install-ios install-android clean