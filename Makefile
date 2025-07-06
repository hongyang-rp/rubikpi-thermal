# Makefile for rubikpi3-thermal

PKG_NAME := rubikpi3-thermal
VERSION := 1.0.1
DEB_VERSION := $(VERSION)-1

DESTDIR ?=
PREFIX ?= /usr
ETC_DIR := $(DESTDIR)/etc
LIB_DIR := $(DESTDIR)/lib

BUILD_DIR := build
DEB_BUILD_DIR := $(BUILD_DIR)/deb
PKG_BUILD_DIR := $(DEB_BUILD_DIR)/$(PKG_NAME)

.PHONY: install uninstall clean deb source binary

export $(dpkg-architecture -aarm64)

install:
	@mkdir -p $(ETC_DIR)/rubikpi
	@mkdir -p $(LIB_DIR)/systemd/system
	@mkdir -p $(LIB_DIR)/systemd/system/multi-user.target.wants

	@install -m 0755 etc/rubikpi/rubikpi_thermal.sh $(ETC_DIR)/rubikpi/rubikpi_thermal.sh
	@install -m 0755 lib/systemd/system/rubikpi-thermal.service $(LIB_DIR)/systemd/system/rubikpi-thermal.service

	@cd $(LIB_DIR)/systemd/system/multi-user.target.wants && \
		ln -sf ../rubikpi-thermal.service

uninstall:
	@rm -f $(ETC_DIR)/rubikpi/rubikpi_thermal.sh
	@rm -f $(LIB_DIR)/systemd/system/rubikpi-thermal.service
	@rm -f $(LIB_DIR)/systemd/system/multi-user.target.wants/rubikpi-thermal.service

deb:
	@fakeroot dh binary

source:
	@tar -cJf ../$(PKG_NAME)_$(VERSION).orig.tar.xz --exclude=debian ./

binary: deb

clean:
	@rm -rf $(BUILD_DIR)
	@dh_clean

