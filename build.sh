#!/bin/sh
chmod +x AppDir/AppRun

# Install required dependencies
if ! command -v file >/dev/null 2>&1; then
    echo "Installing required dependencies..."
    sudo apt-get update && sudo apt-get install -y file
fi

BITFOCUS_COMPANION_URL="https://s4.bitfocus.io/builds/companion/companion-linux-x64-4.0.1+8061-stable-b1c1c1f4dd.tar.gz"

mkdir -p AppDir/companion
if [ ! -f companion.tar.gz ]; then
    echo "Download companion..."
    curl -L $BITFOCUS_COMPANION_URL -o companion.tar.gz
fi
tar -xzf companion.tar.gz -C AppDir/companion --strip-components=1

if ! command -v appimagetool.AppImage >/dev/null 2>&1
then
    echo "Download AppImage tool..."
    curl -L "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" -o appimagetool.AppImage
    chmod +x appimagetool.AppImage
fi

echo "Build AppImage..."
if command -v appimagetool.AppImage >/dev/null 2>&1
then ARCH=x86_64 appimagetool.AppImage -v AppDir
else
    ARCH=x86_64 ./appimagetool.AppImage --appimage-extract-and-run -v AppDir
    rm ./appimagetool.AppImage
fi
