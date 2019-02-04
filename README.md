# lwjgl3-port
FreeBSD port of LWJGL3

### Notes

Build will fail on FreeBSD 11 because the binary `genie` is built for FreeBSD 12. The two options are, build a new one from repo https://github.com/bkaradzic/GENie or use the Linux version by changing the path to genie in the Makefile.

When build is complete, start with

`./minecraft-client-1.13`

From the Minecraft launcher, edit your profile and change the executable to 
`<absolute-path-to-this-repo>/minecraft-runtime-1.13`

