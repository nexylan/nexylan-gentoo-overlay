# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Percona XtraDB Cluster is a high availability and high scalability
solution for MySQL users. XtraDB Cluster integrates Percona Server with the
Galera library of high availability solutions in a single product package"
HOMEPAGE="http://www.percona.com/software/percona-xtradb-cluster/"

MY_P="5.6"
MY_POINT="30"
MY_PATCH="25.16"
MY_BUILD="1"
MY_SSL="101"

MY_PS="${MY_P}.${MY_POINT}-rel76.1-${MY_PATCH}"
MY_PVP="${MY_PS}.${MY_BUILD}"
MY_PN="Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64.ssl${MY_SSL}"

SRC_URI=" (
https://github.com/percona/percona-xtradb-cluster/archive/Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}.tar.gz
https://github.com/percona/galera/archive/3.x.zip
)
"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-util/scons
		dev-libs/boost
		dev-libs/check
		app-arch/unzip"
RDEPEND="${DEPEND}
		dev-libs/libaio
		sys-process/numactl
		>=sys-apps/openrc-0.7.0
		!dev-db/mysql
		!dev-db/mariadb
		"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/galera-3.x ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/percona-xtradb-cluster-galera
	mkdir ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/pxc-build
}

src_compile() {
	cd ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/build-ps/build-binary.sh ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}
	${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/build-ps/build-binary.sh ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/pxc-build
}

src_install() {
	cd ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster-${MY_P}.${MY_POINT}-${MY_PATCH}/pxc-build

	tar -xf *.tar.gz
	cd Percona-XtraDB-Cluster-*

	dodir /etc/mysql/
	dodir /var/lib/mysql/
	fowners mysql /var/lib/mysql/

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

	dosbin bin/mysqld
	rm bin/mysqld

	dobin bin/*
	dobin scripts/*
	dolib lib/*.so*
	dolib.a lib/*.a
	dodoc docs/*

	# libmysql patch
#	dosym /usr/lib64/libmysqlclient.so /usr/lib64/libmysqlclient.so.16

	# libSSL patch
#	dosym /usr/lib64/libssl.so /usr/lib64/libssl.so.6
#	dosym /usr/lib64/libcrypto.so /usr/lib64/libcrypto.so.6

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

