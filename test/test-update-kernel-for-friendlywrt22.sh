#!/bin/bash
set -eu

HTTP_SERVER=112.124.9.243
KERNEL_URL=https://github.com/Forkworks/Fe-kernel-rockchip
KERNEL_BRANCH=nanopi5-v5.10.y_opt

# hack for me
PCNAME=`hostname`
if [ x"${PCNAME}" = x"tzs-i7pc" ]; then
	HTTP_SERVER=127.0.0.1
	KERNEL_URL=git@192.168.1.5:/devel/kernel/linux.git
	KERNEL_BRANCH=nanopi5-v5.10.y_opt
fi

# clean
mkdir -p tmp
sudo rm -rf tmp/*

cd tmp
git clone ../../.git sd-fuse_rk3568
cd sd-fuse_rk3568
if [ -f ../../friendlywrt22-images.tgz ]; then
	tar xvzf ../../friendlywrt22-images.tgz
else
	wget --no-proxy http://${HTTP_SERVER}/dvdfiles/RK3568/images-for-eflasher/friendlywrt22-images.tgz
    tar xvzf friendlywrt22-images.tgz
fi

if [ -f ../../kernel-rk3568.tgz ]; then
	tar xvzf ../../kernel-rk3568.tgz
else
	git clone ${KERNEL_URL} --depth 1 -b ${KERNEL_BRANCH} kernel-rk3568
fi

BUILD_THIRD_PARTY_DRIVER=0 KERNEL_SRC=$PWD/kernel-rk3568 ./build-kernel.sh friendlywrt22
sudo ./mk-sd-image.sh friendlywrt22
