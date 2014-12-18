# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu/libdbusmenu-12.10.2.ebuild,v 1.5 2014/08/20 11:25:43 armin76 Exp $

EAPI=5

VALA_MIN_API_VERSION=0.16
VALA_USE_DEPEND=vapigen
PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools-multilib eutils flag-o-matic multibuild python-single-r1 vala

DESCRIPTION="Library to pass menu structure across DBus"
HOMEPAGE="http://launchpad.net/dbusmenu"
SRC_URI="http://launchpad.net/${PN/lib}/${PV%.*}/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug gtk2 gtk3 +introspection"

#json-glib does not support multilib
RDEPEND="
	>=dev-libs/dbus-glib-0.100[${MULTILIB_USEDEP}]
	>=dev-libs/json-glib-0.13.4[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	gtk3? ( >=x11-libs/gtk+-3.2:3[${MULTILIB_USEDEP},introspection?] )
	gtk2? ( >=x11-libs/gtk+-2.18:2[${MULTILIB_USEDEP},introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	!<${CATEGORY}/${PN}-0.5.1-r200"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	virtual/pkgconfig
	introspection? ( $(vala_depend) )"

src_prepare() {
	epatch ${FILESDIR}/makefile_overwrite_header.patch
	MULTIBUILD_VARIANTS=()
	use gtk2 && MULTIBUILD_VARIANTS+=(gtk2)
	use gtk3 && MULTIBUILD_VARIANTS+=(gtk3)
	if use introspection; then
		vala_src_prepare
		export VALA_API_GEN="${VAPIGEN}"
	fi
	python_fix_shebang tools
}

src_configure() {
	append-flags -Wno-error #414323

	# dumper extra tool is only for GTK+-2.x, tests use valgrind which is stupid
	my_gtk_setup() {
		if [[ ${MULTIBUILD_VARIANT} = gtk2 ]]; then
			GTK_SWITCH="--with-gtk=2"
			multilib_parallel_foreach_abi my_configure
		elif [[ ${MULTIBUILD_VARIANT} = gtk3 ]]; then
			GTK_SWITCH="--with-gtk=3"
			my_configure
		else
			my_configure
		fi
	}

	my_configure() {
		myeconfargs=(
			--docdir=/usr/share/doc/${PF}
			--disable-static
			--disable-silent-rules
			--disable-scrollkeeper
			$( (use_enable gtk2 gtk) || (use_enable gtk3 gtk) )
			--disable-dumper
			$(use_enable introspection)
			$(use_enable introspection vala)
			$(use_enable debug massivedebugging)
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
		else
			autotools-utils_src_compile
		fi
	}

	multibuild_foreach_variant my_compile
}

src_test() { :; } #440192

src_install() {
	my_install() {
		if [[ ${MULTIBUILD_VARIANT} = gtk2 ]]; then
			autotools-multilib_src_install
		else
			autotools-utils_src_install
		fi
	}
	multibuild_foreach_variant my_install
	
	local a b
	for a in ${PN}-{glib,gtk}; do
		b=/usr/share/doc/${PF}/html/${a}
		[[ -d ${ED}/${b} ]] && dosym ${b} /usr/share/gtk-doc/html/${a}
	done

	prune_libtool_files
}