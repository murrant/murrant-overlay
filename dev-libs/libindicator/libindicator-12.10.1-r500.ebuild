# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicator/libindicator-12.10.1-r300.ebuild,v 1.1 2014/03/15 14:03:58 ssuominen Exp $

EAPI=5
inherit autotools-multilib eutils flag-o-matic virtualx multibuild

DESCRIPTION="A set of symbols and convience functions that all indicators would like to use"
HOMEPAGE="http://launchpad.net/libindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test gtk2 +gtk3"
REQUIRED_USE="|| ( gtk2 gtk3 )"

RDEPEND=">=dev-libs/glib-2.22[${MULTILIB_USEDEP}]
	gtk2? ( >=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}] )
	gtk3? ( >=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/dbus-test-runner )"

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	use gtk2 && MULTIBUILD_VARIANTS+=(gtk2)
	use gtk3 && MULTIBUILD_VARIANTS+=(gtk3)
}

src_prepare() {
	epatch ${FILESDIR}/makefile_overwrite_header.patch
}

ECONF_SOURCE=${S}

# gtk+:3 does not support multilib yet
src_configure() {
	append-flags -Wno-error

	my_gtk_setup() {
		if [[ ${MULTIBUILD_VARIANT} = gtk2 ]]; then
			GTK_SWITCH="--with-gtk=2"
			multilib_parallel_foreach_abi my_configure
		fi
		if [[ ${MULTIBUILD_VARIANT} = gtk3 ]]; then
			GTK_SWITCH="--with-gtk=3"
			my_configure
		fi
		
	}

	
	my_configure() {
		myeconfargs=(
			--disable-silent-rules
			--disable-static
			${GTK_SWITCH} 
		)
		autotools-utils_src_configure
	}
	
	multibuild_foreach_variant my_gtk_setup
}

src_compile() {
	my_compile() {
		if [[ ${MULTIBUILD_VARIANT} = gtk2 ]]; then
			autotools-multilib_src_compile
		fi
		if [[ ${MULTIBUILD_VARIANT} = gtk3 ]]; then
			autotools-utils_src_compile
		fi
	}

	multibuild_foreach_variant my_compile
}

src_test() {
	Xemake check #391179
}

src_install() {
	my_install() {
		if [[ ${MULTIBUILD_VARIANT} = gtk2 ]]; then
			autotools-multilib_src_install
		fi
		if [[ ${MULTIBUILD_VARIANT} = gtk3 ]]; then
			autotools-utils_src_install
		fi
	}

	multibuild_foreach_variant my_install
	dodoc AUTHORS ChangeLog NEWS
	prune_libtool_files --all
}
