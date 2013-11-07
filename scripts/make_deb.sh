#!/bin/sh

# update via SVN
#svn up

# find out the current revision
#SVNVERSION="$(export LANG=C && export LC_ALL=C && echo $(svn info | awk '/^Revision:/ { print $2 }'))"

# use checkinstall to create the DEB package
sudo checkinstall -D \
                  --pkgname "mjpg-streamer" \
                  --pkgversion "1.0" \
                  --pkgrelease "1" \
                  --maintainer "tebrandt@frontier.com" \
                  --requires "libjpeg62" \
                  --nodoc \
                    make DESTDIR=/usr install
