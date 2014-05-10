# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit base eutils

DESCRIPTION="Yet Another Metadata Injector for FLV."
HOMEPAGE="http://yamdi.sourceforge.net/"
SRC_URI="mirror://sourceforge/yamdi/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"

IUSE=""

RDEPEND="${DEPEND}"

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dobin yamdi
}
