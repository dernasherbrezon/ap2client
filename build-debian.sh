#!/bin/bash

set -e

DATE=`date +%s`

echo "Version: ${DATE}" >> debian/DEBIAN/control
mkdir -p debian/usr/share/ap2client
cp src/*.sh debian/usr/share/ap2client
chmod +x debian/DEBIAN/postinst

dpkg-deb --build debian ap2client-${DATE}.deb

openssl aes-256-cbc -K $encrypted_806ce29048dc_key -iv $encrypted_806ce29048dc_iv -in codesigning2.asc.enc -out codesigning2.asc -d

gpg --fast-import codesigning2.asc

deb-s3 upload -a armhf -c r2cloud --access-key-id=${AWS_ACCESS_KEY} --secret-access-key=${AWS_SECRET_ACCESS_KEY}  -m main --sign=A5A70917 --gpg-options="--passphrase ${GPG_PASSPHRASE} --digest-algo SHA256" --bucket r2cloud *.deb
