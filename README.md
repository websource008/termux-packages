# Termux packages for the Google Play build of Termux

This repository contains the packages used in the [Termux build on Google Play](https://play.google.com/store/apps/details?id=com.termux&hl=en) .

It's currently mostly interesting if you are a developer looking into the changes necessary to make Termux compatible with the Google Play requirements.

Otherwise, please work on [https://github.com/termux/termux-packages](https://github.com/termux/termux-packages) instead - this repository regularly merges in changes from there.

The plan is to get back to a single repository for Termux packages, this is a transitional repo while the main Termux package repository is not ready for the Google Play requirements.

# Overview of changes
- The `termux-exec` package has been adopted to not `execve(2)` downloaded files directly, but instead execute `/system/bink/linker64 file-to-execute`.
- Some packages have been patched to work with the above.
- The required Android version has been bumped, dropping the need of things like `libandroid-spawn`.
- Some unrelated changes to the build system for simplicity.
- Some packages that did not build has been removed.
- The `x11-packages` and `root-packages` does not exit yet.

More information will follow.
