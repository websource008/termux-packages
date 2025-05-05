termux_step_setup_build_folders() {
	# Following directories may contain files with read-only
	# permissions which makes them undeletable. We need to fix
	# that.
	[ -d "$TERMUX_PKG_BUILDDIR" ] && chmod +w -R "$TERMUX_PKG_BUILDDIR" || true
	[ -d "$TERMUX_PKG_SRCDIR" ] && chmod +w -R "$TERMUX_PKG_SRCDIR" || true
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		# Remove all previously extracted/built files from $TERMUX_PREFIX:
		rm -fr "$TERMUX_PREFIX"
	fi

	# Cleanup old build state:
	rm -Rf "$TERMUX_PKG_BUILDDIR" \
		"$TERMUX_PKG_SRCDIR"

	# Cleanup old packaging state:
	rm -Rf "$TERMUX_PKG_PACKAGEDIR" \
		"$TERMUX_PKG_TMPDIR" \
		"$TERMUX_PKG_MASSAGEDIR"

	# Create required directories, but not `TERMUX_PKG_SRCDIR` as it
	# will be created during build. If `TERMUX_PKG_SRCDIR` were
	# to be created, then `TERMUX_PKG_SRCURL` like for `zip` would get
	# extracted to sub directories in `termux_extract_src_archive()`.
	# If `TERMUX_PKG_BUILD_IN_SRC` is `true`, then `TERMUX_PKG_BUILDDIR`
	# will be equal to `TERMUX_PKG_SRCDIR`, so do not create it in
	# that case.
	if [ "$TERMUX_PKG_BUILDDIR" != "$TERMUX_PKG_SRCDIR" ]; then
		mkdir -p "$TERMUX_PKG_BUILDDIR"
	fi
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_COMMON_CACHEDIR-$TERMUX_ARCH" \
		 "$TERMUX_COMMON_CACHEDIR-all" \
		 "$TERMUX_OUTPUT_DIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR"
	mkdir -p $TERMUX_PREFIX/{bin,etc,lib,libexec,share,share/LICENSES,tmp,include}
}
