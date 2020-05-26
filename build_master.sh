#!/bin/bash

VERSION="$(cat version)"

if [[ "${1}" != "skip" ]] ; then
	./build_clean.sh
fi

./build_kernel.sh || exit 1

if [ -e arch/arm64/boot/Image.gz ] ; then
	echo
	echo "Building Kernel Package"
	echo

	rm IceKernel-$VERSION.zip 2>/dev/null
	rm -rf kernelzip 2>/dev/null

	mkdir kernelzip
	cp -rp ./anykernel/* kernelzip/
	if ( echo $(git branch | sed -n '/\* /s///p') | grep -q 'stock' ); then
		find arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > kernelzip/dtb
	fi
	cd kernelzip/
	7z a -mx9 IceKernel-$VERSION-tmp.zip *
	if ( echo $(git branch | sed -n '/\* /s///p') | grep -q 'stock' ); then
		7z a -mx0 IceKernel-$VERSION-tmp.zip ../arch/arm64/boot/Image.gz
	else
		7z a -mx0 IceKernel-$VERSION-tmp.zip ../arch/arm64/boot/Image.gz-dtb
	fi
	zipalign -v 4 IceKernel-$VERSION-tmp.zip ../IceKernel-$VERSION.zip
	rm IceKernel-$VERSION-tmp.zip
	cd ..
	ls -al IceKernel-$VERSION.zip
fi
