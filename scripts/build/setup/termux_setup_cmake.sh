termux_setup_cmake() {
	local TERMUX_CMAKE_MAJORVERSION=3.29
	local TERMUX_CMAKE_MINORVERSION=3
	local TERMUX_CMAKE_VERSION=$TERMUX_CMAKE_MAJORVERSION.$TERMUX_CMAKE_MINORVERSION
	local TERMUX_CMAKE_TARNAME=cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64.tar.gz
	local TERMUX_CMAKE_TARFILE=$TERMUX_PKG_TMPDIR/$TERMUX_CMAKE_TARNAME
	local TERMUX_CMAKE_FOLDER
	local TERMUX_CMAKE_NAME="cmake"

	if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
		TERMUX_CMAKE_FOLDER=$TERMUX_SCRIPTDIR/build-tools/cmake-$TERMUX_CMAKE_VERSION
	else
		TERMUX_CMAKE_FOLDER=$TERMUX_COMMON_CACHEDIR/cmake-$TERMUX_CMAKE_VERSION
	fi

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		if [ ! -d "$TERMUX_CMAKE_FOLDER" ]; then
			termux_download https://github.com/Kitware/CMake/releases/download/v${TERMUX_CMAKE_VERSION}/$TERMUX_CMAKE_TARNAME \
				"$TERMUX_CMAKE_TARFILE" \
				90b543a30220401db0e08347af067545be158ce89ffb09b7df1516cda8617329
			rm -Rf "$TERMUX_PKG_TMPDIR/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64"
			tar xf "$TERMUX_CMAKE_TARFILE" -C "$TERMUX_PKG_TMPDIR"
			shopt -s nullglob
			local f
			for f in "$TERMUX_SCRIPTDIR"/scripts/build/setup/cmake-*.patch; do
				echo "[${FUNCNAME[0]}]: Applying $(basename "$f")"
				patch --silent -p1 -d "$TERMUX_PKG_TMPDIR/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64" < "$f"
			done
			shopt -u nullglob
			mv "$TERMUX_PKG_TMPDIR/cmake-${TERMUX_CMAKE_VERSION}-linux-x86_64" \
				"$TERMUX_CMAKE_FOLDER"
		fi

		export PATH=$TERMUX_CMAKE_FOLDER/bin:$PATH
	else
		if [[ "$(dpkg-query -W -f '${db:Status-Status}\n' $TERMUX_CMAKE_NAME 2>/dev/null)" != "installed" ]]; then
			echo "Package '$TERMUX_CMAKE_NAME' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install $TERMUX_CMAKE_NAME"
			echo
			exit 1
		fi
	fi

	export CMAKE_INSTALL_ALWAYS=1
}
