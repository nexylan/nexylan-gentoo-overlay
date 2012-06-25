# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit multilib eutils

DESCRIPTION="Percona XtraBackup is OpenSource online (non-blockable) backup tool
for InnoDB and XtraDB engines"
HOMEPAGE="http://www.percona.com/docs/wiki/percona-xtrabackup:start"
SRC_URI="
amd64? (
http://www.percona.com/downloads/XtraBackup/XtraBackup-${PV}/binary/Linux/x86_64/percona-xtrabackup-${PV}.tar.gz
)
"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-libs/zlib
	dev-libs/libaio"

src_install() {
	cd percona-xtrabackup-${PV}/bin
	dobin innobackupex xbstream xtrabackup xtrabackup_51 xtrabackup_55
	dosym innobackupex /usr/bin/innobackupex-1.5.1
}
