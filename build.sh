#!/usr/bin/env sh

ROOT=`pwd`
LIBS=${ROOT}/native-libs
mkdir -p ${LIBS} || exit 1

echo Cloning dependencies...

# Main repo
git clone -b freebsd git@github.com:johalun/lwjgl3.git

# lwjgl3 dependency
git clone -b 1.18.2 git@github.com:johalun/openal-soft.git

# lwjgl3 dependency
git clone -b freebsd git@github.com:johalun/glfw.git

# glfw dependency
git clone -b freebsd git@github.com:johalun/bgfx.git

# bgfx dependency
git clone -b freebsd git@github.com:johalun/bimg.git

# bgfx dependency
git clone -b freebsd git@github.com:johalun/bx.git



# From pkg:
# - dyncall (lwjgl3 dependency)
# - assimp (lwjgl3 dependency)
# - minizip (assimp dependency)
# - gcc
# - gmake
# - cmake
# - and probably lots more...

# Some fail with clang, use gcc across the board for simplicity
export CPP=gcc
export CC=gcc
export CXX=g++


# Clean first so we don't have to do that manually while testing build.

cd openal-soft
rm -fr build
mkdir build
cd build
cmake -DALSOFT_REQUIRE_OSS=ON -DALSOFT_EMBED_HRTF_DATA=YES -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0" .. || exit 1
cmake --build . || exit 1
strip libopenal.so || exit 1
cp libopenal.so ${LIBS}/ || exit 1

echo
echo Building bx
echo ===========
echo

cd ${ROOT}/bx
gmake clean
gmake freebsd-release64 || exit 1

echo
echo Building bimg
echo =============
echo

cd ${ROOT}/bimg
gmake clean
gmake freebsd-release64 || exit 1

echo
echo Building bgfx
echo =============
echo

cd ${ROOT}/bgfx
rm -fr .build
../bx/tools/bin/bsd/genie --with-shared-lib --with-tools --gcc=freebsd gmake || exit 1
echo
echo Building bgfx: bgfx-shared-lib
echo ==============================
echo
gmake -R -C .build/projects/gmake-freebsd config=release64 CFLAGS="-I/usr/local/include -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0" bgfx-shared-lib || exit 1
echo
echo Building bgfx: geometryc
echo ========================
echo
gmake -R -C .build/projects/gmake-freebsd config=release64 CFLAGS="-I/usr/local/include" geometryc || exit 1
echo
echo Building bgfx: texturec
echo =======================
echo
gmake -R -C .build/projects/gmake-freebsd config=release64 CFLAGS="-I/usr/local/include" texturec || exit 1
echo
echo Building bgfx: texturev
echo =======================
echo
gmake -R -C .build/projects/gmake-freebsd config=release64 CFLAGS="-I/usr/local/include" texturev || exit 1
echo
echo Building bgfx: shaderc
echo ======================
echo
gmake -R -C .build/projects/gmake-freebsd config=release64 CFLAGS="-I/usr/local/include" shaderc || exit 1
strip .build/freebsd/bin/libbgfx-shared-libRelease.so || exit 1
cp .build/freebsd/bin/libbgfx-shared-libRelease.so ${LIBS}/ || exit 1


echo
echo Building glfw
echo =============
echo

cd ${ROOT}/glfw
rm -fr build
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-I/usr/local/include -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0" .. || exit 1
cmake --build . || exit 1
cd src
strip libglfw.so
cp libglfw.so ${LIBS}/ || exit 1


echo
echo Building lwjgl3
echo ===============
echo

cd ${ROOT}/lwjgl3
ant clean
ant || exit 1
ant release || exit 1

echo
echo "Build done. Make ROOT in minecraft-runtime-1.13 point to this folder and execute minecraft-client-1.13."
