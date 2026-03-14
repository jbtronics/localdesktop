FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    git \
    make \
    clang \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# NDK version must match the value of NDK_VERSION in the config file
ARG NDK_VERSION=r28
RUN wget -q "https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip" \
         -O /tmp/android-ndk.zip \
    && unzip -q /tmp/android-ndk.zip -d /opt \
    && mv "/opt/android-ndk-${NDK_VERSION}" /opt/android-ndk \
    && rm /tmp/android-ndk.zip

ENV ANDROID_NDK_HOME=/opt/android-ndk

WORKDIR /build-proot-android
COPY . .

RUN chmod +x build.sh get-proot.sh get-talloc.sh make-talloc-static.sh \
               make-proot.sh make-proot-assets.sh pack.sh

# Run the full build
RUN ./build.sh

# The built binaries will be available in:
#   build/root-aarch64/root/bin/proot        (proot binary)
#   build/root-aarch64/root/libexec/proot/   (loader files)
#   packages/                                 (tar.gz archives)
