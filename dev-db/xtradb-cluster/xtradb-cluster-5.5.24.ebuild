# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Percona Server with XtraDB is a backwards-compatible replacement
for MySQL that is much faster and more scalable, easier to monitor and tune, and
has features to make operational tasks easier. It is designed to excel for cloud
computing, support NoSQL access, and take full advantage of modern hardware such
as SSD and Flash storage."
HOMEPAGE="http://www.percona.com/software/percona-server/"

MY_P="5.5"
MY_POINT="24"
MY_PATCH="23.6"
MY_BUILD="342"

MY_PS="${MY_P}.${MY_POINT}-${MY_PATCH}"
MY_PVP="${MY_PS}.${MY_BUILD}"
MY_PN="Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64"

SRC_URI="amd64? (
http://www.percona.com/downloads/Percona-XtraDB-Cluster/${MY_PS}/binary/linux/x86_64/Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64.tar.gz
)
"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		dev-libs/libaio
		>=sys-apps/openrc-0.7.0
		"

src_unpack() {
	unpack ${A}

}

src_compile() {
	true
}

src_install() {
	cd ${WORKDIR}/${MY_PN}/

	dosym /lib64/libncurses.so.5 /lib64/libtinfo.so.5
	dosym /lib64/libcrypto.so /lib64/libcrypto.so.10
	dosym /lib64/libssl.so /lib64/libssl.so.10

	dodir /etc/mysql/
	dodir /var/lib/mysql/

	insinto /etc
	doins bin/*.conf
	rm bin/*.conf

	insinto /etc/conf.d/
	newins ${FILESDIR}/conf.d.mysql mysql

	exeinto /etc/init.d/
	newexe ${FILESDIR}/init.d.mysql mysql

	dosbin bin/mysqld
	rm bin/mysqld

	dobin bin/*
	dobin scripts/*
	dolib lib/*.so*
	dolib.a lib/*.a
	dodoc docs/*

	insinto /usr/lib64/plugin/
	doins -r lib/plugin/*

	insinto /usr/include/mysql/
	doins -r include/*

	insinto /usr/share/man/
	doins -r man/*

	insinto /usr/share/mysql/
	doins -r share/*

	insinto /usr/share/mysql/support-files/
	doins -r support-files/*
}

