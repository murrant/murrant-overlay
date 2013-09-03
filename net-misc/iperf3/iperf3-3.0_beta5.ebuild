# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/iperf/iperf-2.0.5-r1.ebuild,v 1.2 2012/10/06 13:43:23 pinkbyte Exp $

EAPI="4"

inherit base
MY_P="iperf-${PV/_beta/b}"

DESCRIPTION="Tool to measure IP bandwidth using UDP or TCP"
HOMEPAGE="http://code.google.com/p/iperf/"
SRC_URI="http://iperf.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="debug"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"
#PATCHES=( "${FILESDIR}"/"${PN}"-fix-bandwidth-limit.patch )
DOCS="INSTALL README"

src_configure() {
	econf \
		$(use_enable debug debuginfo)
}

src_install() {
	default
}

pkg_postinst() {
	echo
	einfo "To run iperf in server mode, run:"
	einfo "  iperf3 -s"
	echo
}
