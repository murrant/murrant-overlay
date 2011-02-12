# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $
inherit subversion

ESVN_REPO_URI="http://svn.xiph.org/trunk/Tremor/"
ESVN_BOOTSTRAP="autogen.sh"

DESCRIPTION="Reference decoder provides an integer-only implementation of vorbis format for embedded devices"
HOMEPAGE="http://xiph.org/vorbis/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="media-libs/libogg"
DEPEND=""

src_install () {
        emake DESTDIR="${D}" install || die "emake install failed"
}
