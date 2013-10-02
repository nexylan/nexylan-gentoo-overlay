# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.7"

DESCRIPTION="Nexylan agent for system monitoring"
HOMEPAGE="http://www.nexylan.net"
EGIT_REPO_URI="https://github.com/Nexylan/nexyagent.git"

inherit eutils user git-2 python

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	# Control PYTHON_USE_WITH
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	dodoc README.md

	newinitd "${PN}.init" ${PN}

	# Location of data files
	keepdir /usr/local/${PN}

	insinto /etc/${PN}
	insopts -m0664
	doins config.cfg

	insinto /usr/local/${PN}
	doins -r *.py
}

pkg_postinst() {

	# we need to remove .git which old ebuild installed
	if [[ -d "/usr/share/${PN}/.git" ]] ; then
	   ewarn "stale files from previous ebuild detected"
	   ewarn "/usr/share/${PN}/.git removed."
	   ewarn "To ensure proper operation, you should unmerge package and remove
directory /usr/share/${PN} and then emerge package again"
	   ewarn "Sorry for the inconvenience"
	   rm -Rf "/usr/share/${PN}/.git"
	fi

	python_mod_optimize /usr/local/${PN}

	elog "Nexyagent has been installed with data directories in /var/${PN}"
	elog
	elog "Config file is located in /etc/${PN}/${PN}.ini"
	elog "Note: Log files are located in /var/${PN}/logs"
	elog
	elog "Start with ${ROOT}etc/init.d/${PN} start"
	elog
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
