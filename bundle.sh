#!/usr/bin/env bash
#
#  This is an artifacts bundler.  I use it in a /plugins/ directory which zips
#  and then copies to ~/GitHub/wplib/wp-composer-dependencies/artifacts
#

plugin="$1"
version="$2"

zip -9ro "${plugin}-${version}.zip" "${plugin}/"
mv "${plugin}-${version}.zip" ~/GitHub/wplib/wp-composer-dependencies/artifacts
echo ""
echo "\"artifacts/${plugin}\": \"${version}\","