#!/bin/bash
set -e
set -x

cd copasi-dependencies/
echo "===== Deleting old dependencies build"
rm -rf tmp_darwin_x64/ bin_darwin_x64/
echo "===== Building dependencies"
BUILD_DIR=${PWD}/tmp_darwin_x64 \
	INSTALL_DIR=${PWD}/bin_darwin_x64 \
	./createOSX-qt5.sh
cd ../

echo "===== Copying CopasiVersion.h"
cp CopasiVersion.h COPASI/copasi/

echo "===== Deleting old build"
rm -rf corc_darwin_x64/
mkdir corc_darwin_x64/
cd corc_darwin_x64/
echo "===== Running CMake"
cmake \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_GUI=OFF \
	-DBUILD_SE=OFF \
	-DENABLE_R=ON \
	-DR_USE_DYNAMIC_LOOKUP=ON \
	-DCOPASI_DEPENDENCY_DIR=../copasi-dependencies/bin_darwin_x64/ \
	../COPASI/
echo "===== Running Make"
make binding_r_lib
cd ../

echo "===== Copying results into libs/"
mkdir -p libs/
cp corc_darwin_x64/copasi/bindings/R/COPASI.so libs/COPASI_darwin_x86_64.so
cp corc_darwin_x64/copasi/bindings/R/COPASI.so libs/COPASI.so
cp corc_darwin_x64/copasi/bindings/R/COPASI.R libs/swig_wrapper.R
