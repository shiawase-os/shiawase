# shiawase operating system
unix like operating system with a monolithic kernel

## build dependencies
you need to have the following tools on your system:
- `make`
- `wget`
- `tar` + `xz` (often `xz-utils`)
- `sha256sum`

for generating an iso or bootable harddrive image you also need
- `xorriso`
- `mtools` 
- `mkfs.*` 
- `sgdisk`

for testing you also need
- `qemu-system-*` (`*` is the arch you want to test for so `aarch64`, `x86_64` (which includes `i686`))
