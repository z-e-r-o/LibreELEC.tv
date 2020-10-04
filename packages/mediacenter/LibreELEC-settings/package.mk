# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="LibreELEC-settings"
PKG_VERSION="2927e633c278454066d99ac12a5b8f69c8246178"
PKG_SHA256="87de2d653e9cb5942c9babfe91bf4548dcc931f924a0ff057846a4ec1d9d37b7"
PKG_LICENSE="GPL"
PKG_SITE="https://libreelec.tv"
PKG_URL="https://github.com/LibreELEC/service.libreelec.settings/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python3 connman pygobject dbus-python dbussy"
PKG_LONGDESC="LibreELEC-settings: is a settings dialog for LibreELEC"

PKG_MAKE_OPTS_TARGET="DISTRONAME=$DISTRONAME ROOT_PASSWORD=$ROOT_PASSWORD"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET+=" setxkbmap"
else
  PKG_DEPENDS_TARGET+=" bkeymaps"
fi

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libreelec
    cp $PKG_DIR/scripts/* $INSTALL/usr/lib/libreelec
    sed -e "s/@DISTRONAME@/$DISTRONAME/g" \
      -i $INSTALL/usr/lib/libreelec/backup-restore

  ADDON_INSTALL_DIR=$INSTALL/usr/share/kodi/addons/service.libreelec.settings

  python_compile $ADDON_INSTALL_DIR/resources/lib/

  python_compile $ADDON_INSTALL_DIR/defaults.py

  python_compile $ADDON_INSTALL_DIR/oe.py
}

post_install() {
  enable_service backup-restore.service
  enable_service factory-reset.service
}
