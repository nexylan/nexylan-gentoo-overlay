# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Percona XtraDB Cluster is a high availability and high scalability
solution for MySQL users. XtraDB Cluster integrates Percona Server with the
Galera library of high availability solutions in a single product package"
HOMEPAGE="http://www.percona.com/software/percona-xtradb-cluster/"

MY_P="5.7"
MY_POINT="18"
MY_PATCH="29.20"
MY_BUILD="1"
MY_SSL="101"

MY_PS="${MY_P}.${MY_POINT}-${MY_PATCH}"
MY_PVP="${MY_PS}.${MY_BUILD}"
MY_PN="Percona-XtraDB-Cluster-${MY_PS}"

SRC_URI=" (
https://www.percona.com/downloads/Percona-XtraDB-Cluster-LATEST/${MY_PN}/source/tarball/${MY_PN}.tar.gz
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
	mkdir ${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}/pxc-build
}

src_compile() {
	cd ${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}/build-ps/build-binary.sh ${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}
	${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}/build-ps/build-binary.sh ${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}/pxc-build
}

src_install() {
	cd ${WORKDIR}/Percona-XtraDB-Cluster-${MY_PS}/pxc-build

	tar -xf *.tar.gz
	cd Percona-XtraDB-Cluster-*

	dodir /etc/mysql/
	dodir /var/lib/mysql/
	fowners mysql /var/lib/mysql/

	insinto /etc/conf.d/
	newins ${PORTAGE_BUILDDIR}/files/conf.d.mysql mysql

	insinto /etc/init.d/
	newins ${PORTAGE_BUILDDIR}/files/init.d.mysql mysql
	
	insinto /etc/mysql/

	dosbin bin/mysqld
	rm bin/mysqld

	dobin bin/*
	dolib lib/*.so*
	dolib.a lib/*.a
	dodoc docs/*

	insinto /usr/include/mysql/
	doins -r include/*

	insinto /usr/share/man/
	doins -r man/*

	insinto /usr/share/mysql/
	doins -r share/*

}

