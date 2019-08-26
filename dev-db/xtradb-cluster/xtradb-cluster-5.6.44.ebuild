# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Percona XtraDB Cluster is a high availability and high scalability
solution for MySQL users. XtraDB Cluster integrates Percona Server with the
Galera library of high availability solutions in a single product package"
HOMEPAGE="http://www.percona.com/software/percona-xtradb-cluster/"

inherit user

MY_P="5.6"
MY_POINT="44"
MY_PATCH="28.34"
MY_BUILD="1"
MY_SSL="101"

MY_PS="${MY_P}.${MY_POINT}-rel86.0-${MY_PATCH}"
MY_PVP="${MY_PS}.${MY_BUILD}"
MY_PN="Percona-XtraDB-Cluster-${MY_PVP}.Linux.x86_64.ssl${MY_SSL}"
#WSREP_COMMIT="9d8298080296930e12eb4b026736bc58a2bf4476"
WSREP_COMMIT="9d9d30d9e8615c0663e57028f97cb22cfbb55cd2"

SRC_URI=" (
https://github.com/percona/percona-xtradb-cluster/archive/Percona-XtraDB-Cluster_${MY_P}.${MY_POINT}-${MY_PATCH}.tar.gz
https://github.com/percona/galera/archive/pxc_${MY_P}.${MY_POINT}-${MY_PATCH}.tar.gz
https://github.com/percona/wsrep-API/archive/${WSREP_COMMIT}.zip
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
		sys-apps/lsb-release
		dev-libs/libaio
		sys-process/numactl
		>=sys-apps/openrc-0.7.0
		!dev-db/mysql
		!dev-db/mariadb
		"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/percona-xtradb-cluster-Percona-XtraDB-Cluster_${MY_P}.${MY_POINT}-${MY_PATCH}  ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}
	mv ${WORKDIR}/galera-pxc_${MY_P}.${MY_POINT}-${MY_PATCH} ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/percona-xtradb-cluster-galera
	mv ${WORKDIR}/wsrep-API-${WSREP_COMMIT}/* ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/wsrep/src/
	cp ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/wsrep/src/wsrep_api.h  ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/percona-xtradb-cluster-galera/
	mkdir ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/pxc-build
}

src_compile() {
	cd ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}
	${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/build-ps/build-binary.sh ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/pxc-build
}

src_install() {
	cd ${WORKDIR}/xtradb-cluster-${MY_P}.${MY_POINT}/pxc-build

	tar -xf *.tar.gz
	cd Percona-XtraDB-Cluster-${MY_PS}..Linux.x86_64
	#files already provided by mysql-connector-c 
	rm \
                man/man1/my_print_defaults.1 \
                man/man1/perror.1 \
				bin/mysql_config \
				bin/my_print_defaults \
				bin/perror \
				lib/libmysqlclient.so \
				lib/libmysqlclient.so.18 \
				lib/libmysqlclient_r.so \
				lib/libmysqlclient_r.so.18 \
                || die

	dodir /etc/mysql/
	keepdir /var/lib/mysql/
	keepdir /var/log/mysql/
	fowners mysql /var/lib/mysql/
	fowners mysql /var/log/mysql/

	insinto /etc/mysql/
	doins support-files/*.cnf
	#dosym /etc/mysql/my-innodb-heavy-4G.cnf /etc/mysql/my.cnf
	rm support-files/*.cnf

	insinto /etc/conf.d/
	newins "${FILESDIR}"/conf.d.mysql mysql

	newinitd "${FILESDIR}"/init.d.mysql mysql
	
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

	insinto /usr/share/man/
	doins -r man/*

	insinto /usr/share/mysql/
	doins -r share/*

	insinto /usr/share/mysql/support-files/
	doins -r support-files/*
}
pkg_setup(){

        enewgroup mysql 60 || die "problem adding 'mysql' group"
        enewuser mysql 60 -1 /dev/null mysql || die "problem adding 'mysql' user"
}

