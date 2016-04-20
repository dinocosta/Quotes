install:
	mv build/Release/Quotes.app /Applications

build:
	xcodebuild -project Quotes.xcodeproj

clean:
	rm -rf build/

