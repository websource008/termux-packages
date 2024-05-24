TERMUX_PKG_HOMEPAGE=https://invisible-island.net/ncurses/
TERMUX_PKG_DESCRIPTION="Library for text-based user interfaces in a terminal-independent manner"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
# This references a commit in https://github.com/ThomasDickey/ncurses-snapshots, specifically
# https://github.com/ThomasDickey/ncurses-snapshots/commit/${_SNAPSHOT_COMMIT}
# Check the commit description to see which version a commit belongs to - correct version
# is checked in termux_step_pre_configure(), so the build will fail on a mistake.
# Using this simplifies things (no need to avoid downloading and applying patches manually),
# and uses github is a high available hosting.
_SNAPSHOT_COMMIT=801929d34ab7fda3ca77ef59484b34a127adf8d3
TERMUX_PKG_VERSION=(6.5.20240519
                    9.31
                    0.34.1
                    0.13.2)
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=(https://github.com/ThomasDickey/ncurses-snapshots/archive/${_SNAPSHOT_COMMIT}.tar.gz
                   https://fossies.org/linux/misc/rxvt-unicode-${TERMUX_PKG_VERSION[1]}.tar.bz2
                   https://github.com/kovidgoyal/kitty/releases/download/v${TERMUX_PKG_VERSION[2]}/kitty-${TERMUX_PKG_VERSION[2]}.tar.xz
                   https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION[3]}.tar.gz)
TERMUX_PKG_SHA256=(3b0409a769d157a5d4e2bdc9ba336946e1f160f16ab47938a9813bbd96b7559b
                   aaa13fcbc149fe0f3f391f933279580f74a96fd312d6ed06b8ff03c2d46672e8
                   9f6dbb30c018976e14bd959e8db6e5c34055b50f3729bff000bb4e86e283c03e
                   e9a54aabc92bbdc25ab1659c2e5a1e9b76f27d101342c8219cc98a730fd46d90)
TERMUX_PKG_AUTO_UPDATE=false

# --disable-stripping to disable -s argument to install which does not work when cross compiling:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_locale_h=no
am_cv_langinfo_codeset=no
--disable-stripping
--disable-opaque-curses
--enable-const
--enable-ext-colors
--enable-ext-mouse
--enable-overwrite
--enable-pc-files
--enable-termcap
--enable-widec
--mandir=$TERMUX_PREFIX/share/man
--without-ada
--without-cxx-binding
--without-debug
--without-tests
--with-normal
--with-pkg-config-libdir=$TERMUX_PREFIX/lib/pkgconfig
--with-static
--with-shared
--with-termpath=$TERMUX_PREFIX/etc/termcap:$TERMUX_PREFIX/share/misc/termcap
"

TERMUX_PKG_RM_AFTER_INSTALL="
share/man/man5
share/man/man7
"

termux_step_pre_configure() {
	MAIN_VERSION=$(cut -f 2 VERSION)
	PATCH_VERSION=$(cut -f 3 VERSION)
	ACTUAL_VERSION=${MAIN_VERSION}.${PATCH_VERSION}
	EXPECTED_VERSION=${TERMUX_PKG_VERSION[0]}
	if [ "${ACTUAL_VERSION}" != "${EXPECTED_VERSION}"]; then
		termux_error_exit "Version mismatch - expected ${EXPECTED_VERSION}, was ${ACTUAL_VERSION}. Check https://github.com/ThomasDickey/ncurses-snapshots/commit/${_SNAPSHOT_COMMIT}"
	fi
	export CPPFLAGS+=" -fPIC"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib

	# Ncursesw/Ncurses compatibility symlinks.
	for lib in form menu ncurses panel; do
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:3}
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:1}
		ln -sfr lib${lib}w.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so
		ln -sfr lib${lib}w.a lib${lib}.a
		(cd pkgconfig; ln -sf ${lib}w.pc $lib.pc)
	done

	# Legacy compatibility symlinks (libcurses, libtermcap, libtic, libtinfo).
	for lib in curses termcap tic tinfo; do
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:3}
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so.${TERMUX_PKG_VERSION:0:1}
		ln -sfr libncursesw.so.${TERMUX_PKG_VERSION:0:3} lib${lib}.so
		ln -sfr libncursesw.a lib${lib}.a
		(cd pkgconfig; ln -sfr ncursesw.pc ${lib}.pc)
	done

	# Strip away 30 years of cruft to decrease size.
	local TI=$TERMUX_PREFIX/share/terminfo
	mv $TI $TERMUX_PKG_TMPDIR/full-terminfo
	mkdir -p $TI/{a,d,e,g,n,k,l,p,r,s,t,v,x}
	cp $TERMUX_PKG_TMPDIR/full-terminfo/a/ansi $TI/a/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/d/{dtterm,dumb} $TI/d/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/e/eterm-color $TI/e/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/g/gnome{,-256color} $TI/g/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/n/nsterm $TI/n/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/k/kitty{,+common,-direct} $TI/k/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/l/linux $TI/l/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/p/putty{,-256color} $TI/p/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/r/rxvt{,-256color} $TI/r/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/s/{screen{,2,-256color},st{,-256color}} $TI/s/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/t/tmux{,-256color} $TI/t/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/v/{vt52,vt100,vt102} $TI/v/
	cp $TERMUX_PKG_TMPDIR/full-terminfo/x/xterm{,-color,-new,-16color,-256color,+256color} $TI/x/

	tic -x -o $TI $TERMUX_PKG_SRCDIR/rxvt-unicode-${TERMUX_PKG_VERSION[1]}/doc/etc/rxvt-unicode.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/kitty-${TERMUX_PKG_VERSION[2]}/terminfo/kitty.terminfo
	tic -x -o $TI $TERMUX_PKG_SRCDIR/alacritty-${TERMUX_PKG_VERSION[3]}/extra/alacritty.info
}

termux_step_post_massage() {
	# Some packages want these:
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/include" || exit 1
	rm -Rf ncurses{,w}
	mkdir ncurses{,w}

	local _file
	for _file in *.h; do
		ln -s ../$_file ncurses
		ln -s ../$_file ncursesw
	done
}
