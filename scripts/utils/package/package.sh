# shellcheck shell=sh
# shellcheck disable=SC2039,SC2059

# Title:          package
# Description:    A library for package utils.



##
# Check if package on device builds are supported by checking
# `$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED` value in its `build.sh`
# file.
# .
# .
# **Parameters:**
# `package_dir` - The directory path for the package `build.sh` file.
# .
# **Returns:**
# Returns `0` if supported, otherwise `1`.
# .
# .
# package__is_package_on_device_build_supported `package_dir`
##
package__is_package_on_device_build_supported() {
	[ $(. "${1}/build.sh"; echo "$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED") != "true" ]
	return $?
}
