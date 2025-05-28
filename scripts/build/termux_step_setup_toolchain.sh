termux_step_setup_toolchain() {
	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	# Bump TERMUX_STANDALONE_TOOLCHAIN if a change is made in
	# toolchain setup to ensure that everyone gets an updated
	# toolchain
	if [ "${TERMUX_NDK_VERSION}" = "27c" ]; then
		TERMUX_STANDALONE_TOOLCHAIN+="-v1"
		termux_setup_toolchain_27c
	else
		termux_error_exit "We do not have a setup_toolchain function for NDK version $TERMUX_NDK_VERSION"
	fi
}

termux_step_setup_multilib_environment() {
	termux_conf_multilib_vars
	if [ "$TERMUX_PKG_BUILD_ONLY_MULTILIB" = "false" ]; then
		TERMUX_PKG_BUILDDIR="$TERMUX_PKG_MULTILIB_BUILDDIR"
	fi
	termux_step_setup_arch_variables
	termux_step_setup_pkg_config_libdir
	termux_step_setup_toolchain
	cd $TERMUX_PKG_BUILDDIR
}
