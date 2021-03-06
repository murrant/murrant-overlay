# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user unpacker systemd

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="http://influxdb.com"
SRC_URI="https://dl.influxdata.com/influxdb/releases/${PN}_${PV}_amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}

src_unpack() {
	mkdir -p ${WORKDIR}/${P}
	cd ${WORKDIR}/${P}
	unpack_deb ${A}
}

src_install() {
	cp -Rp * "${D}"
#	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
	systemd_dounit "${WORKDIR}/${P}/usr/lib/${PN}/scripts/${PN}.service"
	fowners ${PN}:${PN} /var/log/${PN}
}
