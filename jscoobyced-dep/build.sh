#!/bin/bash

JSCV=""

if [ "" != "$1" ]; then
  if [ -f ".env-$1" ]; then
    JSCV="-$1"
  else
    echo "No .env-$1 file found."
  fi
fi

source .env"${JSCV}"

VERSION=$MAJOR.$MINOR-$REVISION
PACKAGE=${PROJECT}_${VERSION}
DESTINATION=$PACKAGE/usr/share/${PROJECT}
BINS=$PACKAGE/usr/local/bin
DEBIAN=$PACKAGE/DEBIAN

echo "Packaging $PROJECT version $VERSION"

echo "Cleaning up"

rm -Rf ${PROJECT}_*

echo "Creating directory structure"

mkdir $PACKAGE
mkdir -p $DESTINATION $BINS

if [ "-ui" = "${JSCV}" ]; then
  cp ./scripts/* $BINS
fi

echo "Creating DEBIAN structure"

mkdir $DEBIAN

cat > $DEBIAN/control << EOF
Package: ${PROJECT}
Version: ${VERSION}
Section: base
Priority: optional
Architecture: all
Depends: ${PKGDEPENDS}
Maintainer: ${PKGMAINTAINER} <${PKGEMAIL}>
Description: ${PKGDESC}
EOF

cp install"${JSCV}".sh $DEBIAN/postinst

cp preinstall"${JSCV}".sh $DEBIAN/preinst

cp uninstall"${JSCV}".sh $DEBIAN/postrm

chown -Rf root:root $PACKAGE

echo "Building Package"

dpkg-deb --build $PACKAGE