#!/usr/bin/env sh

echo 
echo Make sure you install required build dependencies by executing
echo pkg install git cmake libX11 libXrandr libXinerama libXcursor xinput apache-ant dyncall
echo 
# (there might be more that I've missed)

ROOT=`pwd`
LIBS=${ROOT}/native-libs
mkdir -p ${LIBS} || exit 1

echo Cloning dependencies...

GIT_OPTIONS="--single-branch --depth 1"
#GIT_OPTIONS=""

# lwjgl3 dependency
git clone -b 1.18.2 git@github.com:johalun/openal-soft.git

# lwjgl3 dependency
git clone -b 'freebsd' ${GIT_OPTIONS} git@github.com:johalun/glfw.git

# main repo
git clone -b 'freebsd-3.2.1' ${GIT_OPTIONS} git@github.com:johalun/lwjgl3.git

cd openal-soft
rm -fr build
mkdir build
cd build
cmake -DALSOFT_REQUIRE_OSS=ON -DALSOFT_EMBED_HRTF_DATA=YES -DCMAKE_BUILD_TYPE=Release .. || exit 1
cmake --build . || exit 1
strip libopenal.so || exit 1
cp libopenal.so ${LIBS}/ || exit 1

echo
echo Building glfw
echo =============
echo

cd ${ROOT}/glfw
mkdir -p build
cd build
cmake -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-I/usr/local/include" .. || exit 1
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
