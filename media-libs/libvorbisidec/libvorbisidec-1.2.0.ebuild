# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $

DESCRIPTION="Reference decoder provides an integer-only implementation of vorbis format for embedded devices"
HOMEPAGE="http://xiph.org/vorbis/"
SRC_URI="http://patches.piasek.co.uk/${P}.tar.gz"
#SRC_URI="http://bugs.gentoo.org/attachment.cgi?id=186791"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libogg"
DEPEND=""

src_install () {
        emake DESTDIR="${D}" install || die "emake install failed"
}
