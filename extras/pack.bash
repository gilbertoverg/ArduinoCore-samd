#!/bin/bash -ex

#  pack.*.bash - Bash script to help packaging samd core releases.
#  Copyright (c) 2015 Arduino LLC.  All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

CORE_NAME="samd"
VERSION="1.8.13"
echo $CORE_NAME
echo $VERSION

PWD=`pwd`
FOLDERNAME=`basename $PWD`
FILENAME=core-$CORE_NAME-$VERSION.tar.bz2
echo $FILENAME

rm -f *.tar.bz2
rm -f *.json

cd ..
tar --exclude=extras/** --exclude=.git* --exclude=.* --disable-copyfile -cjhf $FILENAME $FOLDERNAME
cd -

mv ../$FILENAME .

CHKSUM=`sha256sum $FILENAME | awk '{ print $1 }'`
SIZE=`wc -c $FILENAME | awk '{ print $1 }'`

cat extras/json.template |
sed "s/%%VERSION%%/${VERSION}/" |
sed "s/%%FILENAME%%/${FILENAME}/" |
sed "s/%%CHECKSUM%%/${CHKSUM}/" |
sed "s/%%SIZE%%/${SIZE}/" > package_${CORE_NAME}_index.json
