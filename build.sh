#!/bin/sh
set -eu
cd "$(dirname "$0")"
chmod 0755 package/DEBIAN/postinst package/DEBIAN/prerm package/DEBIAN/postrm
chmod 0755 package/var/jb/usr/libexec/altdaemon-ios17-rootless-fix/apply-fix \
           package/var/jb/usr/libexec/altdaemon-ios17-rootless-fix/restore-fix
mkdir -p build
dpkg-deb --build --root-owner-group -Zxz package \
    build/com.amorcool.altdaemonios17rootlessfix_1.0.2_iphoneos-arm64.deb
