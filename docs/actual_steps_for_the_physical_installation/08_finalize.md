Exit chroot and finalize installation:

```
exit
umout -R /mnt
swapoff -a
cryptsetup close root
cryptsetup close swap
poweroff
```
