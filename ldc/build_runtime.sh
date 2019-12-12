#!/bin/sh

source ~/dlang/ldc-*/activate

CC=~/tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc ldc-build-runtime --ninja --dFlags="-w;-mtriple=arm-linux-gnueabihf"

