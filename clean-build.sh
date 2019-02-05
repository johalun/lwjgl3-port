#!/usr/bin/env sh


echo Cleaning build...

rm -fr glfw/build

pushd lwjgl3
ant -Dos.name=Linux -Dplatform=linux clean
popd
