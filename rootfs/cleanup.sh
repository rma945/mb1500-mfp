#!/bin/bash

find /opt/node/include/node/openssl/archs/ -mindepth 1 -maxdepth 1 ! -name "linux-x86_64" -exec rm -rf {} +
find /usr/lib/x86_64-linux-gnu/sane/ -mindepth 1 -maxdepth 1 ! -name "*panamfs*" -exec rm -rf {} +
find /usr/share/cups/locale -mindepth 1 -maxdepth 1 ! -name "*en*" ! -name "*ru*" -exec rm -rf {} +

rm -rf /var/lib/apt/lists/
rm -rf /var/lib/dpkg/info/

rm -rf /usr/share/icons
rm -rf /usr/share/doc
rm -rf /usr/share/bash-completion
rm -rf /usr/share/X11
rm -rf /usr/share/liblouis
rm -rf /usr/share/fonts/type1
rm -rf /usr/share/fonts/X11
rm -rf /usr/share/fonts/opentype
rm -rf /usr/share/man
rm -rf /usr/share/zoneinfo

rm -rf /usr/share/perl
rm -rf /usr/share/locale/
rm -rf /usr/lib/udev/
rm -rf /usr/share/mime/packages
rm -rf /usr/share/mime/application
rm -rf /usr/lib/x86_64-linux-gnu/perl/
rm -rf /usr/lib/x86_64-linux-gnu/perl-base
rm -rf /usr/lib/x86_64-linux-gnu/mfx/
rm -rf /usr/lib/x86_64-linux-gnu/libcodec2.so.1.0
rm -rf /usr/lib/x86_64-linux-gnu/libx265.so.199
rm -rf /usr/lib/x86_64-linux-gnu/libavcodec.so.59.37.100
rm -rf /usr/lib/x86_64-linux-gnu/libmfxhw64.so.1.35

rm -rf /usr/lib/x86_64-linux-gnu/systemd/
rm -rf /usr/lib/x86_64-linux-gnu/libSvtAv1Enc.so.2.3.0
rm -rf /usr/lib/x86_64-linux-gnu/perl/5.40.1/auto/Encode/{JP,KR,CN,TW}

rm -rf /opt/node/include/
rm -rf /opt/node/lib/node_modules/npm/node_modules/node-gyp/
rm -rf /opt/node/lib/node_modules/npm/docs/

rm -rf /opt/scanserver/node_modules/eslint/

# remove unused ppd files
find /usr/share/cups/model/panasonic/ -mindepth 1 -maxdepth 1 ! -name "*MB1500*" -exec rm -rf {} +
find /usr/share/ppd/cupsfilters/ -mindepth 1 -maxdepth 1 ! -name "*Generic-PDF_Printer-PDF*" -exec rm -rf {} +
rm -rf /usr/share/ppd/panasonic/
rm -rf /usr/share/ghostscript/10.00.0/lib/cbjc600.ppd
rm -rf /usr/share/ghostscript/10.00.0/lib/cbjc800.ppd
