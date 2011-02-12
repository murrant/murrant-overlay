# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $
EAPI="2"

#export gst_conf="ivorbis"
inherit gst-plugins-base


KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-${PV}
	media-libs/libvorbisidec"
DEPEND="dev-util/pkgconfig"



src_configure() {
        # disable any external plugin besides the plugin we want
        local plugin gst_conf

        einfo "Configuring to build ${GST_PLUGINS_BUILD} plugin(s) ..."

        for plugin in ${my_gst_plugins_base}; do
                gst_conf="${gst_conf} --disable-${plugin} "
        done

#        for plugin in "vorbis ivorbisdec"; do
	   gst_conf="${gst_conf} --enable-vorbis --enable-ivorbis "
#        done

	einfo ${gst_conf}
	ewarn "Monkies!"

        cd "${S}"
        econf ${@} --with-package-name="Gentoo GStreamer Ebuild" --with-package-origin="http://www.gentoo.org" ${gst_conf}

}

