#!/usr/bin/env sh

echo 
echo Make sure you install required dependencies by executing
echo pkg install minecraft-client dyncall assimp minizip libXcursor libXinerama xinput gtk3 gcc gmake cmake pkgconf apache-ant 
echo 
# (there might be more that I've missed)

ROOT=`pwd`
LIBS=${ROOT}/native-libs
mkdir -p ${LIBS} || exit 1

echo Cloning dependencies...

GIT_OPTIONS="--single-branch --depth 1"
#GIT_OPTIONS=""

# Main repo
git clone -b 'freebsd-3.1.6' ${GIT_OPTIONS} git@github.com:johalun/lwjgl3.git

# lwjgl3 dependency
git clone -b 'lwjgl-3.1.6' ${GIT_OPTIONS} git@github.com:johalun/glfw.git

# Some fail with clang, use gcc across the board for simplicity
# export CPP=gcc
# export CC=gcc
# export CXX=g++

echo
echo Building glfw
echo =============
echo

cd ${ROOT}/glfw
mkdir -p build
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
ant -Dos.name=Linux -Dplatform=linux || exit 1
ant -Dos.name=Linux -Dplatform=linux release || exit 1

echo
echo "Build done. Make ROOT in minecraft-runtime-1.13 point to this folder and execute minecraft-client-1.13."
