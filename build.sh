#!/bin/sh

date=20170208

for i in `cat arch-list`; do
    make clean
    make ARCH="$i"
    make install DESTDIR=`pwd`/out/aosc-os-artworks-"$date"-"$i"
    tar cvf aosc-os-artworks-"$date"-"$i".tar.xz \
            `pwd`/out/aosc-os-artworks-"$date"-"$i"
done
