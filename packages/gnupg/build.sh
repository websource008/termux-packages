TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/
TERMUX_PKG_DESCRIPTION="Implementation of the OpenPGP standard for encrypting and signing data and communication"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.5
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f68f7d75d06cb1635c336d34d844af97436c3f64ea14bcb7c869782f96f44277
TERMUX_PKG_DEPENDS="libassuan, libgcrypt, libgnutls, libgpg-error, libksba, libnpth, libsqlite, readline, pinentry, resolv-conf, zlib"
TERMUX_PKG_SUGGESTS="scdaemon"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-bzip2
--disable-ldap
--enable-sqlite
--enable-tofu
"
# Remove non-english help files:
TERMUX_PKG_RM_AFTER_INSTALL="share/gnupg/help.*.txt"

termux_step_pre_configure() {
	CPPFLAGS+=" -Ddn_skipname=__dn_skipname"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	ln -sf gpg gpg2
}
