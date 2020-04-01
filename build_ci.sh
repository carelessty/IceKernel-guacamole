#!/bin/bash

# IceKernel CI | Powered by Drone | 2020 -
# Setup
export KBUILD_BUILD_USER=misaka
export KBUILD_BUILD_HOST=tp-workstation
export KJOBS="$((`grep -c '^processor' /proc/cpuinfo` * 2))"
export HOME=/drone
git config --global user.email "webmaster@raspii.tech"
git config --global user.name "alk3pInjection"

# Prepare
cd /drone
mkdir build-tools && cd build-tools
git clone https://github.com/kdrag0n/proton-clang --depth=1
cp /drone/src/dtc /usr/bin/
chmod +x /usr/bin/dtc

# Build
cd /drone/src
short_commit="$(cut -c-8 <<< "$(git rev-parse HEAD)")"
./build_master.sh -j${KJOBS} || exit

# Push
cd /drone
git clone https://$GIT_SECRET@github.com/alk3p/IceKernel_CI-Release.git release --depth=1
rel_date=$(date "+%Y%m%e-%H%S"|sed 's/[ ][ ]*/0/g')
mkdir /drone/release/$(cat /drone/src/version)-$rel_date-$short_commit
cp /drone/src/IceKernel*.zip /drone/release/$(cat /drone/src/version)-$rel_date-$short_commit/
cd /drone/release
git add . && git commit -m "[$(cat /drone/src/version)-$rel_date] IceKernel CI Release $short_commit"
git push -f origin master
