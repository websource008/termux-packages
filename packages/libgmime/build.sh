TERMUX_PKG_HOMEPAGE=https://github.com/jstedfast/gmime
TERMUX_PKG_DESCRIPTION="MIME message parser and creator"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.15"
TERMUX_PKG_SRCURL=https://github.com/jstedfast/gmime/releases/download/${TERMUX_PKG_VERSION}/gmime-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=84cd2a481a27970ec39b5c95f72db026722904a2ccf3fdbd57b280cf2d02b5c4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libidn2, zlib"
TERMUX_PKG_BREAKS="libgmime-dev"
TERMUX_PKG_REPLACES="libgmime-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_have_iconv_detect_h=yes
--disable-crypto
--disable-glibtest
"

termux_step_pre_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR"/iconv-detect.h ./
}
