# lwjgl3-port
FreeBSD port of LWJGL3 (only includes dependencies needed for Minecraft client)

### Notes

Step 1
Read through the `build.sh` script. Install binary dependencies if necessary. 


Step 2
Execute `./build.sh`


When build is complete, set `ROOT` in `minecraft-runtime-1.13` to this folder and start with

`./minecraft-client-1.13`

From the Minecraft launcher, edit your profile and change the executable to 
`<absolute-path-to-this-folder>/minecraft-runtime-1.13`

