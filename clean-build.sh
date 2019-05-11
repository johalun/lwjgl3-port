#!/usr/bin/env sh


echo Cleaning build...

rm -fr glfw/build

cd lwjgl3/
ant -Dos.name=Linux -Dplatform=linux clean
cd ..

