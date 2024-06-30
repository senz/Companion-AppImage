#!/bin/sh
chmod +x AppDir/AppRun

BITFOCUS_COMPANION_URL="https://s3.bitfocus.io/builds/companion/companion-linux-x64-3.3.1+7001-stable-ee7c3daa.tar.gz"

mkdir -p AppDir/companion
if [ ! -f companion.tar.gz ]; then
    echo "Download companion..."
    curl -L $BITFOCUS_COMPANION_URL -o companion.tar.gz
fi
tar -xzf companion.tar.gz -C AppDir/companion --strip-components=1

if ! command -v appimagetool.AppImage >/dev/null 2>&1
then
    echo "Download AppImage tool..."
    LATEST_TOOL=$(curl -L "https://api.github.com/repos/AppImage/AppImageKit/releases/latest" | jq -r '.assets[] | select(.name | test("appimagetool-x86_64.AppImage$")) | .browser_download_url')
    curl -L $LATEST_TOOL -o appimagetool.AppImage
    chmod +x appimagetool.AppImage
fi

echo "Build AppImage..."
if command -v appimagetool.AppImage >/dev/null 2>&1
then ARCH=x86_64 appimagetool.AppImage -v AppDir
else
    ARCH=x86_64 ./appimagetool.AppImage --appimage-extract-and-run -v AppDir
    rm ./appimagetool.AppImage
fi
