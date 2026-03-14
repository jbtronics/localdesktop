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
