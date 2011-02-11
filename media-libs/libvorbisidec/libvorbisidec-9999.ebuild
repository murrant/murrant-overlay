# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $
EAPI="2"

inherit subversion autotools
ESVN_REPO_URI="http://svn.xiph.org/trunk/Tremor/"

DESCRIPTION="Reference decoder provides an integer-only implementation of vorbis format for embedded devices"
HOMEPAGE="http://xiph.org/vorbis/"
LICENSE="GPL"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libogg"
DEPEND=""

src_prepare () {
	./autogen.sh || die "autogen.sh failed"
}

#src_install () {
#        emake DESTDIR="${D}" install || die "emake install failed"
#}
