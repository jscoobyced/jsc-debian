#!/bin/sh

rm -Rf jscoobyced-dep*

./build.sh
./build.sh ui
./build.sh dev
./build.sh media

rm -f ../../jscoobyced.github.io/repo/amd64/jscoobyced-dep*.deb
mv jscoobyced-dep*.deb ../../jscoobyced.github.io/base/