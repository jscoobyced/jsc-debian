#!/bin/bash

source .env

VERSION=$MAJOR.$MINOR-$REVISION
PACKAGE=${PROJECT}_${VERSION}
DESTINATION=$PACKAGE/usr/share/${PROJECT}
DEBIAN=$PACKAGE/DEBIAN

echo "Packaging $PROJECT version $VERSION"

echo "Cleaning up"

rm -Rf ${PROJECT}_*

echo "Creating directory structure"

mkdir $PACKAGE
mkdir -p $DESTINATION

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

chown -Rf root:root $PACKAGE

echo "Building Package"

dpkg-deb --build $PACKAGE

rm -f ../../jscoobyced.github.io/repo/amd64/libpango1*
mv libpango1*.deb ../../jscoobyced.github.io/base/