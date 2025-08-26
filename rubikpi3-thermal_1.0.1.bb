SUMMARY = "Fan Management for RUBIK Pi 3"
DESCRIPTION = "Run the script to periodically obtain the temperature and control the fan speed."
HOMEPAGE = "https://github.com/hongyang-rp/rubikpi-thermal"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://debian/copyright;md5=67cb79eb0ef2ec06bbeab6ffb6ec7918"

SRC_URI = "git://github.com/hongyang-rp/rubikpi-thermal.git;protocol=https;branch=main"
SRCREV = "89a252f93aa689b3e9c802ccac7cae3265fac0ef"

PV = "1.0.1"
S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "^rubikpi3.*"

inherit systemd

SYSTEMD_SERVICE:${PN} = "rubikpi-thermal.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} = "bash"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    # Install the thermal management script
    install -d ${D}${sysconfdir}/rubikpi
    install -m 0755 ${S}/etc/rubikpi/rubikpi_thermal.sh ${D}${sysconfdir}/rubikpi/rubikpi_thermal.sh
    
    # Install systemd service file
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/lib/systemd/system/rubikpi-thermal.service ${D}${systemd_system_unitdir}/rubikpi-thermal.service
}

FILES:${PN} = " \
    ${sysconfdir}/rubikpi/rubikpi_thermal.sh \
    ${systemd_system_unitdir}/rubikpi-thermal.service \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"