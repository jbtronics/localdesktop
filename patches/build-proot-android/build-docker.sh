#!/bin/bash
# Build proot for Android using Docker (no local Android NDK needed).
# The resulting binaries are extracted to the APK assets directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ASSETS_LIB_DIR="$SCRIPT_DIR/../../assets/libs/arm64-v8a"

IMAGE_NAME="localdesktop-build-proot"

# Read NDK_VERSION from config (sourcing only the variable we need)
NDK_VERSION=$(grep '^NDK_VERSION=' "$SCRIPT_DIR/config" | cut -d"'" -f2)
if [ -z "$NDK_VERSION" ]; then
    echo "ERROR: Could not read NDK_VERSION from $SCRIPT_DIR/config." >&2
    exit 1
fi

echo "==> Building proot inside Docker (NDK ${NDK_VERSION})..."
docker build --build-arg "NDK_VERSION=${NDK_VERSION}" -t "$IMAGE_NAME" "$SCRIPT_DIR"

echo "==> Extracting proot binaries from Docker image..."
CONTAINER_ID=$(docker create "$IMAGE_NAME")

mkdir -p "$ASSETS_LIB_DIR"

# Extract proot binary
docker cp "$CONTAINER_ID":/build-proot-android/build/root-aarch64/root/bin/proot \
    "$ASSETS_LIB_DIR/libproot.so"

# Extract loader binary (prefer 64-bit, fall back to 32-bit)
LOADER_EXTRACTED=false
if docker cp "$CONTAINER_ID":/build-proot-android/build/root-aarch64/root/libexec/proot/loader \
    "$ASSETS_LIB_DIR/libproot_loader.so" 2>/dev/null; then
    echo "  Extracted 64-bit loader."
    LOADER_EXTRACTED=true
elif docker cp "$CONTAINER_ID":/build-proot-android/build/root-aarch64/root/libexec/proot/loader32 \
    "$ASSETS_LIB_DIR/libproot_loader.so" 2>/dev/null; then
    echo "  Extracted 32-bit loader (no 64-bit available)."
    LOADER_EXTRACTED=true
fi

docker rm "$CONTAINER_ID"

if [ "$LOADER_EXTRACTED" != "true" ]; then
    echo "ERROR: Could not extract the proot loader binary. The build may be incomplete." >&2
    exit 1
fi

echo "==> Done. Binaries written to: $ASSETS_LIB_DIR"
ls -lh "$ASSETS_LIB_DIR/libproot.so" "$ASSETS_LIB_DIR/libproot_loader.so"
