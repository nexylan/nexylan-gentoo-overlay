# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools apache-module

DESCRIPTION="An Apache2 module for running Python WSGI applications"
HOMEPAGE="https://github.com/nexylan/mod_gandalf"
SRC_URI="https://github.com/nexylan/${PN}/archive/${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="99_${PN}"
APACHE2_MOD_DEFINE="GANDALF"
APACHE2_MOD_FILE="${S}/src/.libs/${PN}.so"

need_apache2


src_compile() {
	cd src
	emake prepare
	emake
}

src_install() {
	apache-module_src_install
}
