# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator

MY_PV=$(get_version_component_range 1-2)
MY_V=$(get_version_component_range 1-3)
DESCRIPTION="A Proxy for the MySQL Client/Server protocol"
HOMEPAGE="http://dev.mysql.com/doc/mysql-proxy/en/"
SRC_URI="https://launchpad.net/${PN}/${MY_PV}/${PV}/+download/${P}.tar.gz"
SRC_URI="https://github.com/mysql/mysql-proxy/archive/rel-${MY_V}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
RDEPEND=">=dev-libs/libevent-2.1
	>=dev-libs/glib-2.16
	>=dev-lang/lua-5.1:0"
DEPEND="${RDEPEND}
	>=virtual/mysql-5.0
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	mv /var/tmp/portage/dev-db/mysql-proxy-${MY_V}/work/mysql-proxy-rel-${MY_V} /var/tmp/portage/dev-db/mysql-proxy-${MY_V}/work/mysql-proxy-${MY_V}
	cd "${S}"
	einfo $S
}

src_prepare() {
	sed -i \
		-e 's|_EVENT_VERSION|LIBEVENT_VERSION|g' \
			src/chassis-mainloop.c || die
    ./autogen.sh || die "autogen.sh failed"
}

src_configure() {
	econf \
		--includedir=/usr/include/${PN} \
		--with-mysql \
		--with-lua \
		|| die "econf failed"
}

src_install() {
    S=${WORKDIR}
	einfo $WORKDIR
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd-0.8.0-r1 ${PN} || die
	dodoc ChangeLog NEWS README
	if use examples; then
		docinto examples
		dodoc examples/*.lua || die
		dodoc lib/*.lua || die
	fi
	# mysql-proxy will refuse to start unless the config file is at most 0660.
	insinto /etc/mysql
	insopts -m0660
	doins "${FILESDIR}"/${PN}.cnf || die
}
