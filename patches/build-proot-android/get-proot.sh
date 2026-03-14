#!/bin/bash

set -e
shopt -s nullglob

. ./config

cd "$BUILD_DIR"

if [ -d "proot" ]; then
    if [ ! -d "proot/.git" ]; then
        echo "proot directory exists but is not a git repository; removing stale directory."
        rm -rf proot
    else
        echo "proot source already present, skipping clone."
    fi
fi

if [ ! -d "proot" ]; then
    git clone https://github.com/termux/proot.git
fi

cd proot
git fetch origin
git checkout "$PROOT_COMMIT"
echo "Checked out termux/proot at $PROOT_COMMIT (version $PROOT_VERSION)"
