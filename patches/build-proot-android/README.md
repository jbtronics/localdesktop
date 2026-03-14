# build-proot-android

Build scripts for [termux/proot](https://github.com/termux/proot) targeting Android.
They produce a PRoot binary statically linked with libtalloc, with an unbundled loader,
ready for packaging into the LocalDesktop APK.

The proot version is pinned to the same commit used by
[termux-packages](https://github.com/termux/termux-packages/blob/master/packages/proot/build.sh)
and can be updated by editing the `PROOT_COMMIT` / `PROOT_VERSION` variables in `config`.

## Building with Docker (recommended)

No local Android NDK installation is required.

```bash
cd patches/build-proot-android
./build-docker.sh
```

The script builds proot inside a Docker container (Ubuntu + NDK r28) and copies the resulting
`libproot.so` and `libproot_loader.so` binaries directly into `assets/libs/arm64-v8a/`.

## Building locally

Requirements: Android NDK, `make`, `tar`, `gzip`, `git`.

Set `ANDROID_NDK_HOME` to your NDK installation directory, then:

```bash
cd patches/build-proot-android
./build.sh
```

The `config` file auto-detects whether you are on Linux or macOS. After the build completes,
copy the binaries to the APK assets:

```bash
./make-proot-assets.sh
```

## Automating via GitHub Actions

The provided `.github/workflows/build-proot.yml` workflow can be triggered manually from the
GitHub Actions UI. It builds proot on a Linux runner, strips the binaries, and publishes them
as assets on a `proot-<version>` GitHub release.

## Output files

| File | Description |
|------|-------------|
| `build/root-aarch64/root/bin/proot` | PRoot binary |
| `build/root-aarch64/root/libexec/proot/loader` | 64-bit unbundled loader |
| `packages/proot-android-aarch64.tar.gz` | Packaged archive |

See https://github.com/termux/proot for more info.
