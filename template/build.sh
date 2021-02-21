#!/bin/bash

source .env
VERSION=$MAJOR.$MINOR-$REVISION
PACKAGE=${PROJECT}_${VERSION}
DESTINATION=$PACKAGE/opt/${PROJECT}
DEBIAN=$PACKAGE/DEBIAN

echo "Packaging $PROJECT version $VERSION"

echo "Cleaning up"

rm -Rf ${PROJECT}_*

echo "Creating directory structure"

mkdir -p $DESTINATION
cp -R package/* $DESTINATION/

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

cp install.sh $DEBIAN/postinst

cp uninstall.sh $DEBIAN/postrm

echo "Building Package"

dpkg-deb --build $PACKAGE