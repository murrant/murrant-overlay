# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils unpacker

DESCRIPTION="Steam for Linux"
HOMEPAGE="https://steampowered.com"
SRC_URI="http://media.steampowered.com/client/installer/steam.deb"

LICENSE="steam"
SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="pulseaudio"
DEPEND=""
RDEPEND="virtual/opengl
         x86? (
             x11-libs/libXext
             >=x11-libs/libX11-1.5
             media-libs/libsdl
             media-libs/libtheora
             media-libs/libvorbis
             media-libs/alsa-lib
             media-libs/libogg
             x11-libs/gtk+:2
             media-libs/openal
             >=x11-libs/pixman-0.24.4
             x11-libs/cairo
             dev-libs/libgcrypt
             net-misc/curl
             x11-libs/gdk-pixbuf
             dev-libs/nspr
             dev-libs/nss
             x11-libs/pango
             media-libs/libpng:1.2
             >=sys-libs/glibc-2.15
             >=sys-libs/zlib-1.2.4
             media-libs/libjpeg-turbo
             >=sys-devel/gcc-4.6
             net-print/cups
         )
         amd64? (
             >=app-emulation/emul-linux-x86-baselibs-20121028
             >=app-emulation/emul-linux-x86-gtklibs-20121028
             >=app-emulation/emul-linux-x86-opengl-20121028
             >=app-emulation/emul-linux-x86-sdl-20120520
             >=app-emulation/emul-linux-x86-soundlibs-20121028
             >=app-emulation/emul-linux-x86-xlibs-20121028
             >=sys-libs/glibc-2.15[multilib]
             >=sys-devel/gcc-4.6[multilib]
         )
         media-libs/fontconfig
         media-libs/freetype:2
         pulseaudio? ( media-sound/pulseaudio )
         sys-apps/dbus
         "
S="${WORKDIR}/"

src_unpack() {
    unpack_deb ${A}
    cd ${S}
    epatch "${FILESDIR}/no-extrapkgs.patch"
}

src_install() {
    exeinto "/usr/bin"
    doexe "usr/bin/steam"

    insinto "/usr/lib/steam"
    doins usr/lib/steam/bootstraplinux_ubuntu12_32.tar.xz
    doins usr/lib/steam/steam-install-notify

    dodoc usr/share/doc/steam/{changelog.gz,copyright}
    doman usr/share/man/man6/steam.6.gz

    insinto /usr/share/applications/
    doins usr/share/applications/steam.desktop

    insinto /usr/share/icons/
    doins -r usr/share/icons/

    doicon usr/share/pixmaps/steam.png

}
