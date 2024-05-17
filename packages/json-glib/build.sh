TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/json-glib/${TERMUX_PKG_VERSION%.*}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=97ef5eb92ca811039ad50a65f06633f1aae64792789307be7170795d8b319454
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_BREAKS="json-glib-dev"
TERMUX_PKG_REPLACES="json-glib-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dgtk_doc=disabled
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/installed-tests
libexec/installed-tests
bin/
"

termux_step_pre_configure() {
	ln -s -f $TERMUX_PREFIX/opt/glib/cross/bin/glib-mkenums $TERMUX_PREFIX/bin/glib-mkenums
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/glib-mkenums
}
