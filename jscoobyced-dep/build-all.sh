#!/bin/sh

./build.sh
./build.sh ui
./build.sh dev
rm -f ../../jscoobyced.github.io/repo/amd64/jscoobyced-dep*.deb
mv jscoobyced-dep*.deb ../../jscoobyced.github.io/base/