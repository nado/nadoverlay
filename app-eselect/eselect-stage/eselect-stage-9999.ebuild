# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Gentoo chroot/stage helper"
HOMEPAGE="https://github.com/nado/eselect-stage"
if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/nado/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/nado/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="qemu"

RDEPEND="
	app-admin/eselect
	sys-apps/openrc
	net-misc/curl
	qemu? ( app-emulation/qemu[static-user] )
"

src_install() {
	insinto /usr/share/eselect/modules
	doins stage.eselect

	doinitd etc/init.d/mount-chroot
	doconfd etc/conf.d/mount-chroot

	insinto /etc
	doins -r etc/eselect
}

pkg_postinst() {
	if use qemu ; then
		elog "In order to run foreign arch chroot, you need appropriate targets"
		elog "set in app-emulation/qemu."
		elog "For example, if you intend to chroot into an arm stage, you would need"
		elog "QEMU_USER_TARGETS='arm'"
	fi
}
