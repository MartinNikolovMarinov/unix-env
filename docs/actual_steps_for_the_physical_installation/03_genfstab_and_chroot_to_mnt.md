# Prepare for arch-chroot to mnt

Create the initial fstab:
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Cat the fstab:
```bash
cat /mnt/etc/fstab

# Static information about the filesystems.
# See fstab(5) for details.

# <file system> <dir> <type> <options> <dump> <pass>

# /dev/mapper/root
UUID=feeb69bd-6ace-46ea-9616-30ef6801ac64	/         	ext4      	rw,relatime	0 1

# /dev/nvme0n1p1
UUID=4C3B-1BF5      	/boot     	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2

# /dev/nvme1n1p1
UUID=9432-949C      	/boot/efi-windows	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2

# /dev/mapper/swap
UUID=51075201-0866-497d-98f6-8efe7cca90a0	none      	swap      	defaults  	0 0
```

Finally chroot to the mnt directory:
```bash
arch-chroot /mnt
```
