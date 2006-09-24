#!/bin/sh

[ -z "$1" ] && echo "Usage: $0 <version number>" && exit

FULLNAME=hibernate-script-$1

[ -e $FULLNAME -o -e $FULLNAME.tar.gz ] && echo "Already exists!" && exit

cp -a tags/release-$1 $FULLNAME
fakeroot tar --exclude '.svn' -czvf $FULLNAME.tar.gz $FULLNAME
rm -rf "$FULLNAME"
