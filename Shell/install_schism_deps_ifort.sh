#!/bin/bash
set -e

# === 0. 기본 설정 ===
export PREFIX=$HOME/NETCDF_ifort
export CC=icc
export CXX=icpc
export FC=ifort
export F77=ifort
export F90=ifort
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"

mkdir -p $PREFIX

# === 1. 환경 변수 (Intel OneAPI) ===
source /opt/intel/oneapi/setvars.sh

# === 2. zlib 설치 ===
wget https://zlib.net/zlib-1.2.13.tar.gz
tar -xzf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

# === 3. HDF5 설치 ===
wget https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.14.3.tar.gz
tar -xzf hdf5-1.14.3.tar.gz
cd hdf5-1.14.3
./configure CC=icc FC=ifort --enable-fortran --with-zlib=$PREFIX --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

# === 4. NetCDF-C 설치 ===
wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.2.tar.gz -O netcdf-c-4.9.2.tar.gz
tar -xzf netcdf-c-4.9.2.tar.gz
cd netcdf-c-4.9.2
./configure CC=icc --disable-dap --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

# === 5. NetCDF-Fortran 설치 ===
wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz -O netcdf-fortran-4.6.0.tar.gz
tar -xzf netcdf-fortran-4.6.0.tar.gz
cd netcdf-fortran-4.6.0
./configure CC=icc FC=ifort --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

echo ""
echo "✅ 설치 완료: $PREFIX 에 netCDF 환경 구성됨"
echo "ℹ️ 다음을 .bashrc 등에 추가할 수 있습니다:"
echo "   export LD_LIBRARY_PATH=$PREFIX/lib:\$LD_LIBRARY_PATH"
