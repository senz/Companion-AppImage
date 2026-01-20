#!/bin/sh
chmod +x AppDir/AppRun

# Install required dependencies
if ! command -v file >/dev/null 2>&1; then
    echo "Installing required dependencies..."
    sudo apt-get update && sudo apt-get install -y file
fi

# Set default architectures if not specified
BUILD_ARCHS="${BUILD_ARCHS:-x86_64}"
# Set companion version from environment variable or use default
COMPANION_VERSION="${COMPANION_VERSION:-4.2.3+8775-stable-9badd326db}"

# Download AppImage tool if not present
if ! command -v appimagetool.AppImage >/dev/null 2>&1
then
    echo "Download AppImage tool..."
    curl -L "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage" -o appimagetool.AppImage
    chmod +x appimagetool.AppImage
fi

# Function to map architecture names
map_arch() {
    case "$1" in
        "arm64") echo "arm64" ;;
        "x86_64"|"x64") echo "x64" ;;
        *) echo "$1" ;;
    esac
}

# Function to get AppImage architecture name
get_appimage_arch() {
    case "$1" in
        "arm64") echo "aarch64" ;;
        "x86_64"|"x64") echo "x86_64" ;;
        *) echo "$1" ;;
    esac
}

# Build AppImages for each architecture
for arch in $BUILD_ARCHS; do
    echo "Building AppImage for architecture: $arch"
    
    # Map architecture name for companion URL
    companion_arch=$(map_arch "$arch")
    appimage_arch=$(get_appimage_arch "$arch")
    
    # Construct companion download URL
    BITFOCUS_COMPANION_URL="https://s4.bitfocus.io/builds/companion/companion-linux-${companion_arch}-${COMPANION_VERSION}.tar.gz"
    
    # Create architecture-specific directories
    mkdir -p "AppDir-${arch}/companion"
    
    # Copy base AppDir structure
    cp -r AppDir/* "AppDir-${arch}/" 2>/dev/null || true
    
    # Download companion binary for this architecture
    companion_file="companion-${arch}.tar.gz"
    if [ ! -f "$companion_file" ]; then
        echo "Downloading companion for $arch..."
        curl -L "$BITFOCUS_COMPANION_URL" -o "$companion_file"
    fi
    
    # Extract companion binary
    echo "Extracting companion for $arch..."
    rm -rf "AppDir-${arch}/companion"
    mkdir -p "AppDir-${arch}/companion"
    tar -xzf "$companion_file" -C "AppDir-${arch}/companion" --strip-components=1
    
    # Build AppImage
    echo "Building AppImage for $arch..."
    if command -v appimagetool.AppImage >/dev/null 2>&1; then
        ARCH="$appimage_arch" ./appimagetool.AppImage -v "AppDir-${arch}"
    else
        ARCH="$appimage_arch" ./appimagetool.AppImage --appimage-extract-and-run -v "AppDir-${arch}"
    fi
    
    echo "Completed AppImage build for $arch"
done

echo "All AppImage builds completed!"
echo "Built architectures: $BUILD_ARCHS"
