TODO:
I need a more reasonable split in the fs layout. It does not make sense to have a debian folder and in it things for X11.
I need a better fs split:
```
/fs
  /common
  /debian
  	/wayland
  	/x11
  /arch
  	/wayland
  	/x11
  /macos
  /sway
```
