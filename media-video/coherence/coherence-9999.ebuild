# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/coherence/coherence-0.6.6.2.ebuild,v 1.4 2011/01/26 22:55:49 xarthisius Exp $
EAPI=2

ESVN_REPO_URI="https://coherence.beebits.net/svn/trunk/Coherence"

PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="sqlite"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"

inherit distutils python subversion

MY_P="Coherence-${PV}"

DESCRIPTION="A framework written in Python for DLNA/UPnP components"
HOMEPAGE="https://coherence.beebits.net/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# deps are not exact and need some work
DEPEND="dev-python/louie
	dev-python/twisted
	dev-python/twisted-web
	dev-python/configobj
	dev-python/gst-python
	dev-python/nevow"
RDEPEND="${DEPEND}
	dev-python/axiom
	dev-python/gdata
	dev-python/feedparser
	dev-python/tagpy"

S="${WORKDIR}/${MY_P}"

src_install() {
	DOCS="docs/*"
	distutils_src_install
	newinitd "${FILESDIR}"/coherence-init coherence
}
