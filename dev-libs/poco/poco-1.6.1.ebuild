# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/poco/poco-1.4.6_p4.ebuild,v 1.4 2015/01/08 20:40:46 maekke Exp $

EAPI="5"

inherit cmake-utils

DESCRIPTION="C++ class libraries to simplify the development of network-centric, portable applications"
HOMEPAGE="http://pocoproject.org/"
SRC_URI="https://github.com/pocoproject/poco/archive/poco-${PV}-release.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xml json mongodb pdf util net ssl crypto data sqlite mysql odbc 7z zip apache2 cppparser doc pagecompiler file2pagecompiler tests"

DEPEND="
    >=dev-util/cmake-3.2.2
    >=dev-libs/libpcre-8.13
    dev-libs/expat
    zip? ( sys-libs/zlib )
    7z? ( app-arch/p7zip )
    apache2? ( www-servers/apache dev-libs/apr-util )
    mongodb? ( dev-db/mongodb )
    mysql? ( virtual/libmysqlclient )
    odbc? ( dev-db/unixODBC )
    sqlite? ( dev-db/sqlite )
    ssl? ( dev-libs/openssl )
    tests? ( dev-util/cppunit )
    "

RDEPEND="${DEPEND}"
REQUIRED_USE="
    apache2? ( net util )
    doc? ( cppparser util xml )
    mysql? ( data )
    odbc? ( data )
    mongodb? ( data )
    sqlite? ( data )
    file2pagecompiler? ( pagecompiler )
    pagecompiler? ( net util xml json )
    ssl? ( net crypto util )
    zip? ( util xml )
    tests? ( util xml json data? ( sqlite ) )
"

# TODO: Add support bundled 7z

S="${WORKDIR}/${PN}-${P}-release"


src_prepare() {
    epatch "${FILESDIR}/poco-1.6.0-apache-deps.patch"
}

src_configure() {
        local mycmakeargs=(
            $(cmake-utils_use_enable xml                XML)
            $(cmake-utils_use_enable json               JSON)
            $(cmake-utils_use_enable mongodb            MONGODB)
            $(cmake-utils_use_enable pdf                PDF)
            $(cmake-utils_use_enable util               UTIL)
            $(cmake-utils_use_enable net                NET)
            $(cmake-utils_use_enable ssl                NETSSL)
            $(cmake-utils_use_enable crypto             CRYPTO)
            $(cmake-utils_use_enable data               DATA)
            $(cmake-utils_use_enable sqlite             DATA_SQLITE)
            $(cmake-utils_use_enable mysql              DATA_MYSQL)
            $(cmake-utils_use_enable odbc               DATA_ODBC)
            $(cmake-utils_use_enable 7z                 SEVENZIP)
            $(cmake-utils_use_enable zip                ZIP)
            $(cmake-utils_use_enable apache2            APACHECONNECTOR)
            $(cmake-utils_use_enable cppparser          CPPPARSER)
            $(cmake-utils_use_enable doc                POCODOC)
            $(cmake-utils_use_enable pagecompiler       PAGECOMPILER)
            $(cmake-utils_use_enable file2pagecompiler  PAGECOMPILER_FILE2PAGE)
            $(cmake-utils_use_enable tests              TESTS)
            -DPOCO_STATIC=OFF
            -DPOCO_UNBUNDLED=TRUE
        )
        
        cmake-utils_src_configure
}
