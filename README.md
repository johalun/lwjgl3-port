# Minecraft 1.13 to 1.17 on FreeBSD
This repo contains
- Build script to fetch and compile code required to run Minecraft (works with minecrafte versions from 1.13)
- Self-contained launcher script for Minecraft client


Dependencies are 
- https://github.com/johalun/lwjgl3
- https://github.com/johalun/glfw
- https://github.com/johalun/openal-soft

### Instructions

Step 1
Read through the `build.sh` script. Install binary dependencies if necessary. 


Step 2
Execute `./build.sh`


When build is complete, set `ROOT` in `minecraft-runtime-1.13` to this folder and start with

`./minecraft-client-1.13`

From the Minecraft launcher, edit your profile and change the executable to 
`<absolute-path-to-this-folder>/minecraft-runtime-1.13`

For minecraft versions 1.17 and upwards you need to use at least openjdk16, this is provied in
`<absolute-path-to-this-folder>/inecraft-runtime-openjdk16`
