#!/bin/sh
set -eu

VERSION="$(sed -rne 's,^VERSION="(.+)",\1,p' hibernate.sh)"
PREFIX="hibernate-script-"

TARGETDIR="../$PREFIX$VERSION"
TARBALL="../$PREFIX$VERSION.tar.gz"

if [ -f "$TARBALL" ]; then
  echo "E: $TARBALL already exists." >&2
  exit 1
fi

if [ -d .git ] && [ -f .git/config ]; then
  git archive --prefix=$PREFIX$VERSION/ HEAD | gzip -9 > $TARBALL
  exit 0
fi

if [ -d "$TARGETDIR" ]; then
  echo "E: $TARGETDIR already exists." >&2
  exit 1
fi

svn export --quiet . "$TARGETDIR"
tar -czC .. -f "$TARBALL" "${TARGETDIR#../}"

echo "tarball created: $TARBALL" >&2

rm -r "$TARGETDIR"

exit 0
