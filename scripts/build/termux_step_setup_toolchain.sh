termux_step_setup_toolchain() {
	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	# Bump TERMUX_STANDALONE_TOOLCHAIN if a change is made in
	# toolchain setup to ensure that everyone gets an updated
	# toolchain
	TERMUX_STANDALONE_TOOLCHAIN+="-v4"
	termux_setup_toolchain
}
