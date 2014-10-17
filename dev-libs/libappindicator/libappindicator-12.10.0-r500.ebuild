# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0.ebuild,v 1.3 2013/05/12 14:40:30 pacho Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit autotools-multilib eutils multibuild vala

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
SRC_URI="http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection gtk2 +gtk3"
REQUIRED_USE="|| ( gtk2 gtk3 )"

RDEPEND=">=dev-libs/dbus-glib-0.98[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.26[${MULTILIB_USEDEP}]
	>=dev-libs/libdbusmenu-0.6.2[${MULTILIB_USEDEP},gtk2?,gtk3?]
	>=dev-libs/libindicator-12.10.0[${MULTILIB_USEDEP},gtk2?,gtk3?]
	gtk3? ( >=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP}] )
	gtk2? ( >=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	introspection? ( $(vala_depend) )"

pkg_setup() {
	MULTIBUILD_VARIANTS=()
	use gtk2 && MULTIBUILD_VARIANTS+=(gtk2)
	use gtk3 && MULTIBUILD_VARIANTS+=(gtk3)
}

src_prepare() {
	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
	use introspection && vala_src_prepare

	#disable python for gtk2 builds
	use gtk2 && epatch ${FILESDIR}/multilib_disable_python.patch
	use gtk2 && epatch ${FILESDIR}/disable_bindings.patch
}

#ECONF_SOURCE=${S}

src_configure() {
	# http://bugs.gentoo.org/409133
	export APPINDICATOR_PYTHON_CFLAGS=' '
	export APPINDICATOR_PYTHON_LIBS=' '
	
	eautomake

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
			--with-html-dir=/usr/share/doc/${PF}/html
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
	dodoc AUTHORS ChangeLog

	prune_libtool_files
}
