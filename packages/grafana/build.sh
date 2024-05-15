TERMUX_PKG_HOMEPAGE=https://grafana.com/
TERMUX_PKG_DESCRIPTION="The open-source platform for monitoring and observability"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.5.27
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/grafana/grafana
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="SPEC_TARGET= MERGED_SPEC_TARGET="

termux_step_pre_configure() {
	termux_setup_golang
	termux_setup_nodejs

	local bin=$TERMUX_PKG_BUILDDIR/_bin
	mkdir -p $bin
	GOOS=linux GOARCH=amd64 go build build.go
	mv build $bin/_build
	local goexec=$bin/go_$(go env GOOS)_$(go env GOARCH)_exec
	cat > $goexec <<-EOF
		#!$(command -v sh)
		shift
		exec $bin/_build -goos=$GOOS -goarch=$GOARCH "\$@"
		EOF
	chmod 0755 $goexec

	local _YARN_VERSION=1.22.19
	local _YARN_URL=https://yarnpkg.com/downloads/${_YARN_VERSION}/yarn-v${_YARN_VERSION}.tar.gz
	termux_download $_YARN_URL "$TERMUX_PKG_CACHEDIR"/yarn-v${_YARN_VERSION}.tar.gz 732620bac8b1690d507274f025f3c6cfdc3627a84d9642e38a07452cc00e0f2e
	cd "$TERMUX_PKG_TMPDIR"
	tar xf "$TERMUX_PKG_CACHEDIR"/yarn-v${_YARN_VERSION}.tar.gz
	PATH=$PWD/yarn-v$_YARN_VERSION/bin:$PATH
	cd -

	export NODE_OPTIONS=--max-old-space-size=6000
	NODE_OPTIONS+=" --openssl-legacy-provider"

	yarn set version 3.2.4
}

termux_step_make() {
	make $TERMUX_PKG_EXTRA_MAKE_ARGS build-go
	make $TERMUX_PKG_EXTRA_MAKE_ARGS deps-js
	make $TERMUX_PKG_EXTRA_MAKE_ARGS build-js
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*/grafana-server bin/*/grafana-cli
	local sharedir=$TERMUX_PREFIX/share/grafana
	mkdir -p $sharedir
	for d in conf public; do
		cp -rT $d $sharedir/$d
	done
}
