#!/bin/sh

# Generate Windows package folders with variant builds

# Number of parallel make processes
PM=12

NAME="jdupes"

VER="$(cat version.h | grep '#define VER "' | cut -d\" -f2)"
echo "Program version: $VER"

TA=mac64
PKGNAME="${NAME}-${VER}-$TA"

echo "Generating package for: $PKGNAME"
mkdir -p "$PKGNAME"
test ! -d "$PKGNAME" && echo "Can't create directory for package" && exit 1
cp CHANGES README.md LICENSE $PKGNAME/
make clean && make -j$PM ENABLE_DEDUPE=1 stripped && cp ${NAME} $PKGNAME/${NAME}
make clean && make -j$PM ENABLE_DEDUPE=1 LOUD=1 stripped && cp ${NAME} $PKGNAME/${NAME}-loud
make clean && make -j$PM LOW_MEMORY=1 stripped && cp ${NAME} $PKGNAME/${NAME}-lowmem
zip -9r ${PKGNAME}.zip $PKGNAME/
echo "Package generation complete."
