PLATFORM_IOS = iOS Simulator,name=iPhone 14 Pro Max
PLATFORM_MACOS = macOS
PLATFORM_TVOS = tvOS Simulator,name=Apple TV
PLATFORM_WATCHOS = watchOS Simulator,name=Apple Watch Series 7 (45mm)

format:
	swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		./Sources ./Tests ./Package.swift

test:
	xcodebuild test \
		-scmProvider system \
		-scheme "HTTP" \
		-destination platform="$(PLATFORM_IOS)"
	xcodebuild test \
		-scmProvider system \
		-scheme "HTTP" \
		-destination platform="$(PLATFORM_MACOS)"
	xcodebuild test \
		-scmProvider system \
		-scheme "HTTP" \
		-destination platform="$(PLATFORM_TVOS)"
	xcodebuild test \
		-scmProvider system \
		-scheme "HTTP" \
		-destination platform="$(PLATFORM_WATCHOS)"
