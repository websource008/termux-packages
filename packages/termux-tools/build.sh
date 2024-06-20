TERMUX_PKG_HOMEPAGE=https://github.com/termux-play-store/termux-tools
TERMUX_PKG_DESCRIPTION="Basic system tools for Termux"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.7"
TERMUX_PKG_SRCURL=https://github.com/termux-play-store/termux-tools/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8cb6f20820e92b003dff7adbab60b8b5ee290506110798de8c5a4fa8a8aa09dc
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_SUGGESTS="termux-api"

# Some of these packages are not dependencies and used only to ensure
# that core packages are installed after upgrading (we removed busybox
# from essentials).
TERMUX_PKG_DEPENDS="coreutils, curl, dash, diffutils, findutils, gawk, grep, less, procps, psmisc, sed, tar, termux-am, termux-exec, util-linux"

# Optional packages that are distributed as part of bootstrap archives.
TERMUX_PKG_RECOMMENDS="ed, dos2unix, inetutils, net-tools, patch, unzip"

termux_step_pre_configure() {
	autoreconf -vfi
}
