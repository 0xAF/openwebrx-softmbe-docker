#!/bin/bash

BUILD_PACKAGES="curl gnupg1 git-core debhelper cmake libprotobuf-dev protobuf-compiler libcodecserver-dev"

apt update
apt install -y curl gnupg1
curl https://repo.openwebrx.de/debian/key.gpg.txt | apt-key add
echo "deb https://repo.openwebrx.de/debian/ experimental main" > /etc/apt/sources.list.d/openwebrx-experimental.list
apt update

apt install -y $BUILD_PACKAGES
cd

# install mbelib
git clone https://github.com/szechyjs/mbelib.git
cd mbelib
dpkg-buildpackage
cd ..
rm -rf mbelib
dpkg -i libmbe1_1.3.0_*.deb libmbe-dev_1.3.0_*.deb
rm *.deb


# install codecserver-softmbe
git clone https://github.com/knatterfunker/codecserver-softmbe.git
cd codecserver-softmbe
# ignore missing library linking error in dpkg-buildpackage command
sed -i 's/dh \$@/dh \$@ --dpkg-shlibdeps-params=--ignore-missing-info/' debian/rules
dpkg-buildpackage
cd ..
rm -rf codecserver-softmbe
dpkg -i codecserver-driver-softmbe_0.0.1_*.deb
rm *.deb

# link the library to the correct location for the codec server
ln -s /usr/lib/x86_64-linux-gnu/codecserver/libsoftmbe.so /usr/local/lib/codecserver/

# add the softmbe library to the codecserver config
cat >> /usr/local/etc/codecserver/codecserver.conf << _EOF_
[device:softmbe]
driver=softmbe
_EOF_

apt-get -y purge --autoremove $BUILD_PACKAGES
apt-get clean
rm -rf /var/lib/apt/lists/*


