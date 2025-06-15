# Bitfocus Companion AppImage

[Bitfocus Companion](https://bitfocus.io/companion) bundled in an AppImage. It is built with the [AppImage tool](https://github.com/AppImage/appimagetool).

## Building

### Single Architecture Build (default)
```bash
./build.sh
```
This builds for x86_64 only (default behavior).

### Multi-Architecture Build
```bash
BUILD_ARCHS="arm64 x86_64" ./build.sh
```
This builds AppImages for both ARM64 and x86_64 architectures.

### ARM64 Only Build
```bash
BUILD_ARCHS="arm64" ./build.sh
```
This builds only for ARM64 architecture.

## Architecture Mapping
- `arm64` → Downloads `companion-linux-arm64-*.tar.gz` → Builds `aarch64` AppImage
- `x86_64` or `x64` → Downloads `companion-linux-x64-*.tar.gz` → Builds `x86_64` AppImage

## Output Files
For each architecture, the script will create:
- `AppDir-{arch}/` - Architecture-specific AppDir
- `companion-{arch}.tar.gz` - Downloaded companion binary
- `Bitfocus_Companion-{appimage_arch}.AppImage` - Final AppImage

## Releases
The GitHub workflow automatically creates releases with tags in the format:
```
companion-{version}-{run_number}
```

For example: `companion-4.0.1+8061-stable-b1c1c1f4dd-42`

Where:
- `{version}` is the Companion version being built
- `{run_number}` is the incremental GitHub Actions run number

## Version Configuration
The companion version can be set via environment variable:
```bash
# Set version for the build
COMPANION_VERSION="4.0.1+8061-stable-b1c1c1f4dd" ./build.sh

# Or export it
export COMPANION_VERSION="4.0.1+8061-stable-b1c1c1f4dd"
./build.sh
```

If not specified, it defaults to `4.0.1+8061-stable-b1c1c1f4dd`.

### GitHub Workflow
The workflow allows you to specify version and architectures when manually triggered:
1. Go to the **Actions** tab in your GitHub repository
2. Select **Build and Release** workflow
3. Click **Run workflow**
4. Optionally specify:
   - **Companion version**: e.g., `4.0.2+8062-stable-xyz123` (leave empty for default)
   - **Build architectures**: e.g., `arm64 x86_64` or `x86_64` (leave empty for default)

For automatic builds (push to main), it uses the default values:
- Version: `4.0.1+8061-stable-b1c1c1f4dd`
- Architectures: `arm64 x86_64`

### Combined Example
```bash
# Build multi-arch with specific version
BUILD_ARCHS="arm64 x86_64" COMPANION_VERSION="4.0.1+8061-stable-b1c1c1f4dd" ./build.sh
```
