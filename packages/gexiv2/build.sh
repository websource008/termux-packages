TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/gexiv2
TERMUX_PKG_DESCRIPTION="A GObject-based Exiv2 wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gexiv2/${TERMUX_PKG_VERSION%.*}/gexiv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2a0c9cf48fbe8b3435008866ffd40b8eddb0667d2212b42396fdf688e93ce0be
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, glib, libc++"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=false
-Dvapi=false
-Dpython3=false
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LIBCPP_ENABLE_CXX17_REMOVED_FEATURES"
}

termux_step_pre_configure() {
	ln -s -f $TERMUX_PREFIX/opt/glib/cross/bin/glib-mkenums $TERMUX_PREFIX/bin/glib-mkenums
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/glib-mkenums
}
