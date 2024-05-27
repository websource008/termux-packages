#!/usr/bin/env bash
set -e -u

TERMUX_ARCH_BITS=64
TERMUX_HOST_PLATFORM=aarch64
TERMUX_PKG_SRCDIR=/tmp/termux-src
TERMUX_PKG_HOSTBUILD_DIR=/tmp/termux-hostbuild-dir
TERMUX_PKG_CACHEDIR=/tmp/termux-pkg-cachedir
TERMUX_PKG_BUILDER_DIR=/tmp/termux-pkg-builder-dir
TERMUX_PKG_BUILDDIR=/tmp/termux-pkg-builddir
TERMUX_PKG_NAME=TODO
TERMUX_PKG_TMPDIR=/tmp/termux-pkg-tmpdir
TERMUX_DEBUG_BUILD=false
TERMUX_PKG_API_LEVEL=28
TERMUX_PYTHON_VERSION=3.11
TERMUX_BUILD_TUPLE=x86_64-pc-linux-gnu
TERMUX_PYTHON_HOME=/tmp/termux-python-home

TERMUX_SCRIPTDIR=$(dirname "$(realpath "$0")")/..
TERMUX_ON_DEVICE_BUILD=false
. "$TERMUX_SCRIPTDIR"/scripts/properties.sh

check_package() { # path
	local path=$1
	local pkg=$(basename "$path")
	TERMUX_PKG_REVISION=0
	TERMUX_ARCH=aarch64
	. "$path"/build.sh
	if [ "$TERMUX_PKG_REVISION" != "0" ] || [ "$TERMUX_PKG_VERSION" != "${TERMUX_PKG_VERSION/-/}" ]; then
		TERMUX_PKG_VERSION+="-$TERMUX_PKG_REVISION"
	fi
	echo "$pkg=$TERMUX_PKG_VERSION"
}

for path in "${TERMUX_SCRIPTDIR}"/packages/*; do
(
	check_package "$path"
)
done
