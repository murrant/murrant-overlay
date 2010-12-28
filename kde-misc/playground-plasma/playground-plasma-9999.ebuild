# Copyright 2007-2009 by the individual contributors of the genkdesvn project
# Based in part upon the respective ebuild in Gentoo which is: 
# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

KMNAME="playground/base"
KMMODULE="plasma"

OPENGL_REQUIRED="optional"
inherit kde4-meta
SLOT="live"

DESCRIPTION="Extra Plasma applets and engines."
HOMEPAGE="http://www.kde.org/"

KEYWORDS="amd64 x86"
IUSE="debug networkmanager python kdeprefix"
LICENSE="GPL-2 LGPL-2"

DEPEND="
	kde-base/kdelibs:${SLOT}[opengl?,kdeprefix=]
	kde-base/kdepimlibs:${SLOT}[kdeprefix=]
	kde-base/plasma-workspace:${SLOT}[kdeprefix=]
	kde-base/qimageblitz
	x11-libs/qt-webkit
	kde-base/marble:${SLOT}[kdeprefix=]
	>=dev-cpp/eigen-2.0.0
	networkmanager? ( kde-base/solid:${SLOT}[networkmanager,kdeprefix=] )
	python? ( dev-lang/python:2.6 )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's:{CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces:{DBUS_INTERFACES_INSTALL_DIR}:g' \
		-i "${S}/plasma/containments/cluttereddesktop/CMakeLists.txt" \
		|| die "Setting correct dbus path failed."


	sed -e '/add_subdirectory(virus)/s/^/#DONOTCOMPILE /' \
		-i "${S}"/plasma/wallpapers/CMakeLists.txt || die 'Sed failed.'

	# Fix:
	# crystal applet fails to compile
#	sed -e '/add_subdirectory(crystal)/s/^/#DONOTCOMPILE /' \
#		-i "${S}"/plasma/applets/CMakeLists.txt || die 'Sed failed.'

	# Fix:
	# lionmail applet fails to compile
#	sed -e '/add_subdirectory(lionmail)/s/^/#DONOTCOMPILE /' \
#		-i "${S}"/plasma/applets/CMakeLists.txt || die 'Sed failed.'
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DDBUS_INTERFACES_INSTALL_DIR=${KDEDIR}/share/dbus-1/interfaces/
		-DCMAKE_INSTALL_PREFIX=${KDEDIR}
		-DDBUS_SYSTEM_POLICY_DIR=/etc/dbus-1/system.d
		-DWITH_Blitz=On
		-DWITH_KdepimLibs=On
		$(cmake-utils_use_with networkmanager NetworkManager)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with python PythonLibs)"

	kde4-meta_src_configure
einfo CMAKE_SOURCE_DIR:${CMAKE_SOURCE_DIR}

}

#		-DCMAKE_MODULE_PATH=/usr/kde/live/share/apps/cmake/modules/
#		-DSENSORS_FOUND=No
#		-DWITH_Sensors=Off
#		$(cmake-utils_use_with sensors Sensors)
