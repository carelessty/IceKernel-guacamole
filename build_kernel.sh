#!/bin/bash

export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=../build-tools/proton-clang/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=../build-tools/proton-clang/bin/aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=../build-tools/proton-clang/bin/arm-linux-gnueabi-
export LD_LIBRARY_PATH=../build-tools/proton-clang/lib:$LD_LIBRARY_PATH

echo
echo "Setting defconfig"
echo
# cp defconfig .config
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip sm8150-perf_defconfig

echo
echo "Compiling kernel"
echo 
make CC=clang AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip -j$(nproc --all) || exit 1