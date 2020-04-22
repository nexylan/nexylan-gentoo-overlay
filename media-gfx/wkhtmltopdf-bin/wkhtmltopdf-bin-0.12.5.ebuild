# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="https://wkhtmltopdf.org/ https://github.com/wkhtmltopdf/wkhtmltopdf/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!media-gfx/wkhtmltopdf
	media-libs/libpng:1.6
	media-libs/libjpeg-turbo
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libX11
	dev-libs/openssl
	dev-libs/expat
	dev-libs/libbsd
	sys-libs/zlib
"

src_unpack(){
	mkdir ${P}
	cd ${P}
	tar xf ${FILESDIR}/wkhtmltox-${PV}.gentoo.tar.xz
}

src_install(){
	dobin wkhtmltox/bin/*
	dolib.so wkhtmltox/lib/*
	uncompress wkhtmltox/share/man/man1/*
	doman wkhtmltox/share/man/man1/*
	doheader wkhtmltox/include/wkhtmltox/*
}

