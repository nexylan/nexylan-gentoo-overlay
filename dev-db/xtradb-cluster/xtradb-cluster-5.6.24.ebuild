# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Percona XtraDB Cluster is a high availability and high scalability
solution for MySQL users. XtraDB Cluster integrates Percona Server with the
Galera library of high availability solutions in a single product package"
HOMEPAGE="http://www.percona.com/software/percona-xtradb-cluster/"

MY_P="5.6"
MY_POINT="24"
MY_PATCH="25.11"
MY_BUILD=""

MY_PS="${MY_P}.${MY_POINT}-rel72.2-${MY_PATCH}"
MY_PVP="${MY_PS}.${MY_BUILD}"
MY_PN="Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64"

SRC_URI="amd64? (
http://www.percona.com/downloads/Percona-XtraDB-Cluster-56/Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/binary/tarball/Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64.tar.gz
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
		!dev-db/mysql
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
	dosym /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.10
	dosym /usr/lib64/libssl.so /usr/lib64/libssl.so.10

	dodir /etc/mysql/
	dodir /var/lib/mysql/

	insinto /etc/mysql/
	doins support-files/*.cnf
	#dosym /etc/mysql/my-innodb-heavy-4G.cnf /etc/mysql/my.cnf
	rm support-files/*.cnf

	insinto /etc/conf.d/
	newins ${FILESDIR}/conf.d.mysql mysql

	insinto /etc/init.d/
	newins ${FILESDIR}/init.d.mysql mysql
	fperms 0755 ${FILESDIR}/init.d.mysql
	
	insinto /etc/mysql/
	doins ${FILESDIR}/my.cnf

	dosbin bin/mysqld
	rm bin/mysqld

	dobin bin/*
	dobin scripts/*
	dolib lib/*.so*
	dolib.a lib/*.a
	dodoc docs/*

	# libmysql patch
	dosym /usr/lib64/libmysqlclient.so /usr/lib64/libmysqlclient.so.16

	# libSSL patch
	dosym /usr/lib64/libssl.so /usr/lib64/libssl.so.6
	dosym /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.6

	#insinto /usr/lib64/plugin/
	#doins -r lib/plugin/*

	insinto /usr/include/mysql/
	doins -r include/*

	insinto /usr/share/man/
	doins -r man/*

	insinto /usr/share/mysql/
	doins -r share/*

	insinto /usr/share/mysql/support-files/
	doins -r support-files/*
}

