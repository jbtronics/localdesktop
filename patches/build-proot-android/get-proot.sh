#!/bin/bash

set -e
shopt -s nullglob

. ./config

cd "$BUILD_DIR"

if [ -d "proot" ]; then
    echo "proot source already present, skipping clone."
else
    git clone https://github.com/termux/proot.git
fi

cd proot
git fetch origin
git checkout "$PROOT_COMMIT"
echo "Checked out termux/proot at $PROOT_COMMIT (version $PROOT_VERSION)"

# Apply local patches to the proot source
for PATCH in "$BASE_DIR/proot-patches"/*.patch; do
    echo "Applying patch: $(basename "$PATCH")"
    if patch -p1 --dry-run < "$PATCH" > /dev/null 2>&1; then
        patch -p1 < "$PATCH"
        echo "Patch applied successfully: $(basename "$PATCH")"
    elif patch -p1 --dry-run -R < "$PATCH" > /dev/null 2>&1; then
        echo "Patch already applied, skipping: $(basename "$PATCH")"
    else
        echo "Warning: patch $(basename "$PATCH") could not be applied and does not appear to be already applied." >&2
    fi
done
