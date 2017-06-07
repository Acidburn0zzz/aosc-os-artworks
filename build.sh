#!/bin/sh

date=20170607

for i in `cat arch-list`; do
    make clean
    make ARCH="$i"
    make install DESTDIR=`pwd`/out/aosc-os-artworks-"$date"-"$i"
    ( cd out
    tar cvf aosc-os-artworks-"$date"-"$i".tar.xz \
            aosc-os-artworks-"$date"-"$i"
    )
done
