#!/bin/bash

set -e
set -x

CROSS_COMPILE=/opt/elinos-6.1/cdk/arm/v8hf/glibc-2.19/bin/aarch64-unknown-linux-gnu-

${CROSS_COMPILE}gcc -ggdb -c -o start.o start.S
${CROSS_COMPILE}gcc -ggdb -c -std=gnu99 -Wall -O2 -o app.o app.c
${CROSS_COMPILE}ld -Bstatic --gc-sections -nostartfiles -nostdlib -o app.elf -T app.lds start.o app.o
${CROSS_COMPILE}objcopy --gap-fill=0xff -j .text -j .rodata -j .data -O binary app.elf app.bin
${CROSS_COMPILE}objdump -d app.elf > app.dis
rm -rf kernel8.img
cp app.bin kernel8.img
